# 🚀 Voice Calling Agent + Abandoned Cart CRM

## App run configuration

-- Version :
Flutter : 3.38.7

## Overview

This project is a mini CRM system designed to help agents recover abandoned carts through voice
calling.

It simulates real-world workflows used in e-commerce businesses.

---

## Features

## Authentication

* Login with persistent session (Sqflite)

## Dashboard

* Real-time stats (Abandoned, Converted, Revenue)
* Glass UI with dark theme

## Abandoned Cart System

* View user carts
* Product + value + time tracking

## Call System

* Simulated voice calling
* Call statuses:

    * Connected
    * Busy
    * Not Answered

## Call Actions

* Interested → Converted
* Not Interested → Lost
* Call Later → Follow-up

## Notes System

* Add notes after calls
* Track conversation history

## Follow-up System

* Manage pending leads

## Smart Insights

* High-value cart detection

## Analytics

* Call performance charts
* Conversion insights

---

## Architecture

* State Management: Provider
* Database: Sqflite
* Structure:

    * Providers → Business Logic
    * Screens → UI
    * Services → Database

---

## Real-World Concept

This app represents how **call center agents work in real CRM systems**:

* Leads (Abandoned carts)
* Calls (Conversion attempts)
* Notes (Customer history)
* Follow-ups (Pipeline management)

---

## Future Improvements

* Twilio / Exotel integration
* AI call assistant
* Push notifications
* Auto dialer system

---
