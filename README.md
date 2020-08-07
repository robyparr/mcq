<p align="center">
  <img src="app/assets/images/icon.png" alt="MCQ Icon" />
</p>

## Overview
MCQ stands for "Media Consumption Queue" and is a web service to help collect; organize; and, most importantly, consume media. I created MCQ because I found myself saving links for media I wanted to consume later all over the place and often ended up never actually consuming them. MCQ is an attempt to remedy that problem.

## Getting Started

**Install dependencies**

```
bundle install
yarn install
```

**Setup the database**

```
bundle exec rails db:create db:migrate
```

**Run the project**

```
foreman s -f Procfile.dev
```
