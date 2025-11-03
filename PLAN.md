# Migration Plan for Spring PetClinic to Java 21 and Google Cloud

This plan outlines the steps to modernize the Spring PetClinic application, upgrade it to Java 21, and prepare it for deployment on Google Cloud, based on the `spring-petclinic-java-mod.md` assessment report.

## 1. Strategic Recommendations (High-Level)

*   **Stabilize and Upgrade the Platform**: Move from Spring Boot `4.0.0-M3` to a stable, production-ready GA version (e.g., Spring Boot 3.3.x) that officially supports Java 21.
*   **Remediate Security and Performance Issues**: Externalize hardcoded secrets using Google Cloud Secret Manager, integrate Spring Security for CSRF protection, and refactor JPA fetching strategies to `FetchType.LAZY`.
*   **Adopt a Phased Cloud Migration Strategy**: Deploy the application on Google Kubernetes Engine (GKE) and migrate the database to Cloud SQL.
*   **Leverage Modern Java and Cloud-Native Features**: Adopt Java 21 features like Virtual Threads and integrate with Google Cloud's observability suite.

## 2. Prioritized Work Plan

### Phase 1: Preparation & Environment Standardization

*   **Standardize Build Tool**: Decide on a single build system (Maven or Gradle).
*   **Update CI to Use JDK 21**: Modify GitHub Actions workflows to use JDK 21.
*   **Update Build Files for Java 21**: Adjust `pom.xml` and `build.gradle` to set Java version to `21`.
*   **Update Development Environments**: Revise `.devcontainer/devcontainer.json` and `.devcontainer/Dockerfile` for Java 21.

### Phase 2: Dependency & Framework Alignment

*   **Upgrade Spring Boot Version**: Update `spring-boot-starter-parent` to the latest stable Spring Boot 3.3.x.
*   **Audit and Update All Dependencies**: Systematically update all third-party dependencies.
*   **Resolve `javax` vs. `jakarta` Conflicts**: Ensure all dependencies align with `jakarta.*` namespace.

### Phase 3: Code Refactoring & Modernization

*   **Run Static Analysis with Java 21 Rules**: Configure and run static analysis tools.
*   **Address Deprecated Code**: Refactor usage of deprecated APIs.
*   **Pattern Matching for `instanceof`**: Refactor `PetValidator.java` to use pattern matching.
*   **Bug Fix and Refactoring in `EntityUtils`**: Replace `==` with `.equals()` for `Integer` comparison and remove redundant type check.
*   **Externalize Hardcoded Secrets**: Remove database credentials from `k8s/db.yml`, `application-mysql.properties`, and `application-postgres.properties`, and integrate with Google Cloud Secret Manager.
*   **Integrate Spring Security**: Add `spring-boot-starter-security` dependency for CSRF protection.
*   **Upgrade Frontend Dependencies**: Upgrade `font-awesome` to the latest version.
*   **Inefficient JPA Fetching Strategy**: Change `FetchType.EAGER` to `FetchType.LAZY` for collections in `Owner.java`, `Pet.java`, and `Vet.java`.
*   **Leverage Virtual Threads (Java 21)**: Enable `spring.threads.virtual.enabled=true` in `application.properties`.
*   **(Enhancement) Refactor DTOs with Java Records**: Consider refactoring `Vets` and other simple data carriers into Java Records.
*   **(Enhancement) Adopt `var` for Local Variable Type Inference**: Use `var` where appropriate for local variables.

### Phase 4: Comprehensive Testing

*   **Execute Full Test Suite**: Run all existing unit, integration, and service tests.
*   **Performance Benchmark Testing**: Establish a baseline on Java 17 and rerun on Java 21.
*   **Security Scanning**: Run vulnerability scans on dependencies.

### Phase 5: Deployment & Post-Migration on Google Cloud

*   **Build Java 21 Docker Image**: Create a final Docker image using a minimal Java 21 base image.
*   **Deploy to Staging Environment on GKE**: Deploy the application and Cloud SQL database to a staging cluster.
*   **User Acceptance Testing (UAT)**: Perform end-to-end manual testing.
*   **Plan Production Rollout**: Plan a blue-green or canary deployment strategy.
*   **Establish Cloud Monitoring Dashboards**: Create dashboards in Cloud Monitoring.
*   **Structured Logging**: Configure Logback to output logs in JSON format for Google Cloud Logging.
*   **Leverage Application Metrics with Micrometer**: Add `micrometer-registry-stackdriver` to export metrics to Google Cloud Monitoring.
*   **JVM Tuning for Containers**: Use percentage-based JVM flags for memory management.

## 3. Google Cloud Target Architecture & Services

*   **Compute**: Google Kubernetes Engine (GKE)
*   **Database**: Cloud SQL (for PostgreSQL or MySQL)
*   **CI/CD**: Cloud Build
*   **Artifact Storage**: Artifact Registry
*   **Observability**: Cloud Monitoring & Cloud Logging
*   **Secrets Management**: Secret Manager
*   **Future (Serverless)**: Cloud Run for decomposed microservices.
