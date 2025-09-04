import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

buildscript {
    val kotlin_version by extra("2.0.21")
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.1.1")
        classpath("com.google.gms:google-services:4.3.15")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir = layout.buildDirectory.dir("../../build").get()
layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(name)
    layout.buildDirectory.set(newSubprojectBuildDir)
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
