# Podman Rootless Deployment - Custom Container Image
# Base image: Red Hat UBI (Universal Base Image)
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

# Metadata labels
LABEL maintainer="YourName <your@email.com>"
LABEL version="1.0"
LABEL description="Rootless Podman web application container"

# Install nginx
RUN microdnf install -y nginx shadow-utils && \
    microdnf clean all && \
    rm -rf /var/cache/dnf

# Create non-root user for security
RUN useradd -u 1001 -r -g 0 -s /sbin/nologin appuser

# Copy application files
COPY ./app /usr/share/nginx/html

# Fix permissions for rootless execution
RUN chown -R 1001:0 /usr/share/nginx/html && \
    chmod -R g=u /usr/share/nginx/html && \
    chown -R 1001:0 /var/log/nginx && \
    chown -R 1001:0 /var/run

# Expose non-privileged port
EXPOSE 8080

# Switch to non-root user
USER 1001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

CMD ["nginx", "-g", "daemon off;"]