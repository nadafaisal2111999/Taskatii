# 📝 Taskatii - Task Management & Productivity App

**Taskatii** is a clean, intuitive, and modern mobile application built with **Flutter** to help users manage their daily tasks efficiently, track completed goals, and organize their schedules seamlessly.

---

## 📸 Screenshots

| Home & Dark Mode | Add Task & Profile | Customization |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/8817c111-663d-45dc-bc72-d081829f75fe" width="220"/> <img src="https://github.com/user-attachments/assets/ef96f026-368a-45bf-a75c-b7c8edb9cd36" width="220"/> | <img src="https://github.com/user-attachments/assets/c8298370-de9d-4b0f-b289-25a5f648eeed" width="220"/> <img src="https://github.com/user-attachments/assets/a5e2c0b3-e6d6-47db-a2aa-c7c24fb3168f" width="220"/> | <img src="https://github.com/user-attachments/assets/c1c0692b-cc1b-4fe6-9e51-7d47309a0fb1" width="220"/> <img src="https://github.com/user-attachments/assets/2ad58e84-6e22-46e8-a973-98813f2b9218" width="220"/> |

---

## ✨ Features

* 📌 **Task Management:** Create, view, and organize daily tasks easily.
* 👤 **User Profile & Customization:** Personalize your profile with custom user name and profile picture from the device gallery.
* 💾 **Local Data Persistence:** Instant local saving of tasks and user preferences using **Hive**.
* 🌓 **Dark & Light Mode:** Seamless toggle between Dark Mode and Light Mode for optimal viewing experience.
* ✅ **Completed Tasks Tracking:** Dedicated section to view completed tasks (`Done Tasks`).
* 🖼️ **Image Picker Integration:** Select and save profile images using `image_picker`.

---

## 🛠️ Tech Stack & Architecture

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **Local Database:** [Hive](https://pub.dev/packages/hive) & [Hive Flutter](https://pub.dev/packages/hive_flutter)
* **Image Selection:** [Image Picker](https://pub.dev/packages/image_picker)
* **State Management:** `StatefulWidget` & `ValueNotifier` for theme switching

---

## 📁 Project Structure

```text
lib/
 ├── main.dart             # App entry point & Hive initialization
 └── screens/
      ├── HomeScreen.dart   # Main tasks dashboard & navigation
      ├── userScreen.dart   # Profile settings & picture selection
      ├── Add_Task.dart     # Interface to create new tasks
      └── DoneTaskes.dart   # Archive of completed tasks
