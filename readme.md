# 📝 ToDoList

![Swift](https://img.shields.io/badge/Swift-6.0-orange)
![Platform](https://img.shields.io/badge/Platform-iOS-blue)
![Architecture](https://img.shields.io/badge/Architecture-VIPER-lightgrey)
![Project Manager](https://img.shields.io/badge/Project-Tuist-green)
![License](https://img.shields.io/badge/License-MIT-black)

Менеджер задач для iOS, построенный на **VIPER-архитектуре** с
использованием **Tuist** для генерации и управления Xcode-проектом.

Проект демонстрирует: - Чистую модульную архитектуру - Современный
UIKit-подход (Diffable Data Source + Compositional Layout) -
Масштабируемую структуру - Scaffold-генерацию новых модулей

------------------------------------------------------------------------

# 📚 Содержание

- [Стек технологий](#-стек-технологий)
- [Архитектура](#-архитектура)
- [Установка и запуск](#-установка-и-запуск)
- [Scaffold генерация модулей](#-scaffold-генерация-модулей)
- [Требования](#-требования)

------------------------------------------------------------------------

# 🚀 Стек технологий

## Core

- **Language:** Swift 6.0
- **Minimum iOS:** iOS 15+
- **UI:** UIKit
- **Architecture:** VIPER
- **Project management:** Tuist

## UI

- UICollectionView
- Compositional Layout
- NSDiffableDataSource
- Modern List Configuration
- SnapKit

## Networking

- Alamofire
- RequestBuilder Pattern

## Persistence

- CoreData

------------------------------------------------------------------------

# 🏗 Архитектура

Проект построен на **VIPER**:

    View
    Interactor
    Presenter
    Entity
    Router

## Поток данных

- **View** --- отображение UI и передача пользовательских событий
- **Presenter** --- бизнес-логика отображения и подготовка данных
- **Interactor** --- работа с данными (сеть / CoreData)
- **Entity** --- модели
- **Router** --- навигация

## Особенности реализации

- Каждый модуль изолирован
- Используется Dependency Injection
- Нет прямых связей между View и Interactor
- Навигация полностью инкапсулирована в Router

------------------------------------------------------------------------

## Разделение модулей

- **App** --- точка входа
- **Features** --- фичевые VIPER-модули
- **Core** --- переиспользуемая инфраструктура
- **Shared** --- общие утилиты и расширения

------------------------------------------------------------------------

# 🛠 Установка и запуск

## 1️⃣ Установка Tuist

Если Tuist не установлен:

    curl -LsSf https://install.tuist.io | sh

Проверка установки:

    tuist version

------------------------------------------------------------------------

## 2️⃣ Клонирование репозитория

    git clone https://github.com/youruser/ToDoList.git
    cd ToDoList

------------------------------------------------------------------------

## 3️⃣ Генерация проекта

    tuist install
    tuist generate

После генерации откройте:

    ToDoList.xcworkspace

------------------------------------------------------------------------

# 🏗 Scaffold генерация модулей

Для создания нового VIPER-модуля:

    tuist scaffold viper --name ModuleName

После выполнения будет создан полный набор файлов:

- ModuleNameView
- ModuleNamePresenter
- ModuleNameInteractor
- ModuleNameRouter
- ModuleNameEntity

------------------------------------------------------------------------

# ⚙️ Требования

- macOS 14
- Xcode 16
- Swift 6.
- Tuist 4+

------------------------------------------------------------------------

# 📌 Планы по развитию

- [ ] Unit Tests для Interactor и Presenter
- [ ] UI Tests
- [ ] Swift Concurrency (async/await)
- [ ] CI/CD
- [ ] Lint + SwiftFormat
- [ ] Feature flags

------------------------------------------------------------------------
