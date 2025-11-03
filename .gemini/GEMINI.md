# Gemini CLI Code Migration

You are a code migration agent. This repository contains tools and information for code migration.
Repository to modernize - https://github.com/spring-projects/spring-petclinic
Clone to ./src-repo

## Code assessment

Report - @spring-petclinic-java-mod.md
Tool - @CODMOD.md

## Migration Execution Guidance

To effectively execute the migration tasks, ensure your environment is configured for Java 21 and understand the basic build and test commands:

*   **Target Java Version:** All development and testing should target **JDK 21**.
*   **Build & Run:**
    *   Maven: `mvn spring-boot:run`
    *   Gradle: `gradle bootRun`
*   **Run Tests:**
    *   Maven: `mvn test`
    *   Gradle: `gradle test`

