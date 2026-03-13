---
name: java-kotlin-builder
description: Build and modify Java or Kotlin backend services with attention to Gradle or Maven structure, Spring or Ktor wiring, null-safety, transaction boundaries, and testable service design. Use when implementing endpoints, services, repositories, configuration, or domain logic in Java or Kotlin projects.
---

# Java Kotlin Builder

Use this skill for JVM backend work in Java or Kotlin.

## Focus Areas

- module and package boundaries
- Spring or Ktor wiring
- DTO, entity, and domain separation
- transaction and persistence boundaries
- null-safety, exception flow, and configuration safety

## Workflow

1. Inspect build files and app entrypoints first:
   - `build.gradle*`
   - `pom.xml`
   - framework config
2. Identify the changed layer:
   - controller or route
   - service
   - repository
   - config
   - domain model
3. Check common risks:
   - DTO/entity leakage
   - missing transaction boundary
   - blocking call in coroutine or reactive path
   - unsafe null handling
4. Prefer the smallest layer-consistent change.
5. Verify with existing tests and targeted build commands.

## Guardrails

- In Kotlin, preserve null-safety instead of falling back to platform-type guesswork.
- In Spring, avoid pushing business logic into controllers.
- For data model changes, call out migration or serialization impact.
- If the project mixes Java and Kotlin, follow the dominant local style in each module.
