allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// flutter_jailbreak_detection gibi eski pluginler AGP 8+/9+'da zorunlu olan
// namespace'i kendi build.gradle'inda tanimlamiyor, build'i kiriyor.
// plugins.withId kullaniliyor: afterEvaluate, evaluationDependsOn(":app") nedeniyle
// proje zaten evaluate olmus oluyor ve "already evaluated" hatasi veriyor.
subprojects {
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.gradle.LibraryExtension> {
            if (namespace == null) {
                namespace = "io.flutter.plugins.${project.name.replace("-", "_")}"
            }
            compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
        }
        // AGP 8+/9+, namespace'in sadece build.gradle DSL'inden gelmesini zorunlu kilar;
        // eski pluginlerin manifest'indeki package="..." attribute'u artik desteklenmiyor
        // (Gradle'in kendi hata mesaji da bu attribute'un kaldirilmasini oneriyor).
        val manifestFile = file("$projectDir/src/main/AndroidManifest.xml")
        if (manifestFile.exists()) {
            val content = manifestFile.readText()
            val cleaned = content.replace(Regex("""\s+package="[^"]*""""), "")
            if (cleaned != content) {
                manifestFile.writeText(cleaned)
            }
        }
    }
    plugins.withId("org.jetbrains.kotlin.android") {
        extensions.configure<org.jetbrains.kotlin.gradle.dsl.KotlinAndroidProjectExtension> {
            compilerOptions {
                jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
