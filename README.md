# FLoop-Habit-Tracker
A Flutter clone of the popular [Loop Habit Tracker](https://github.com/iSoron/uhabits).  
**This is NOT a 1:1 clone** there are differences in the UI and how data is stored and handled

---

## Screenshots

<table>
  <tr>
    <td align="center" style="padding: 5px;">
      <a href="https://github.com/user-attachments/assets/519f6c13-d314-4b14-b953-a444e3fb1425" target="_blank" rel="noopener noreferrer">
        <img src="https://github.com/user-attachments/assets/519f6c13-d314-4b14-b953-a444e3fb1425" alt="homescreen-light" width="200" />
      </a>
    </td>
    <td align="center" style="padding: 5px;">
      <a href="https://github.com/user-attachments/assets/83514f60-cf46-4490-896f-1593f417d67c" target="_blank" rel="noopener noreferrer">
        <img src="https://github.com/user-attachments/assets/83514f60-cf46-4490-896f-1593f417d67c" alt="homescreen-dark" width="200" />
      </a>
    </td>
    <td align="center" style="padding: 5px;">
      <a href="https://github.com/user-attachments/assets/fbee742b-235a-48ca-abfc-8d3a73939500" target="_blank" rel="noopener noreferrer">
        <img src="https://github.com/user-attachments/assets/fbee742b-235a-48ca-abfc-8d3a73939500" alt="measurable-visualization-light" width="200" />
      </a>
    </td>
    <td align="center" style="padding: 5px;">
      <a href="https://github.com/user-attachments/assets/0cad9036-293e-472d-b6c2-bf907ac4115c" target="_blank" rel="noopener noreferrer">
        <img src="https://github.com/user-attachments/assets/0cad9036-293e-472d-b6c2-bf907ac4115c" alt="measurable-visualization-dark" width="200" />
      </a>
    </td>
  </tr>
  <tr>
    <td align="center" style="padding: 5px;">
      <a href="https://github.com/user-attachments/assets/d2901d19-1eb5-4df4-9dfc-12eb131da497" target="_blank" rel="noopener noreferrer">
        <img src="https://github.com/user-attachments/assets/d2901d19-1eb5-4df4-9dfc-12eb131da497" alt="yes-no-visualization-light" width="200" />
      </a>
    </td>
    <td align="center" style="padding: 5px;">
      <a href="https://github.com/user-attachments/assets/5bf3b6e6-d648-46f6-8e9a-be5f662faea0" target="_blank" rel="noopener noreferrer">
        <img src="https://github.com/user-attachments/assets/5bf3b6e6-d648-46f6-8e9a-be5f662faea0" alt="yes-no-visualization-dark" width="200" />
      </a>
    </td>
    <td align="center" style="padding: 5px;">
      <a href="https://github.com/user-attachments/assets/d95b78f0-a6ba-47c5-a821-c80a94dbc7aa" target="_blank" rel="noopener noreferrer">
        <img src="https://github.com/user-attachments/assets/d95b78f0-a6ba-47c5-a821-c80a94dbc7aa" alt="yes-no-habit-creator-light" width="200" />
      </a>
    </td>
    <td align="center" style="padding: 5px;">
      <a href="https://github.com/user-attachments/assets/411d8a64-ded6-4734-a4d4-504ba7c82f72" target="_blank" rel="noopener noreferrer">
        <img src="https://github.com/user-attachments/assets/411d8a64-ded6-4734-a4d4-504ba7c82f72" alt="measurable-habit-creator-dark" width="200" />
      </a>
    </td>
  </tr>
</table>

---

## Motivation

- I loved using Loop Habit Tracker, but found it frustrating that habits couldn’t sync between devices or platforms—each phone kept its own data. 
- I decided to build this Flutter version to explore cross-platform development and to lay the groundwork for future synchronization features.
- Although sync isn’t implemented yet, you can already access the raw data file on Android (`/storage/emulated/0/habits.json`) and sync it manually (for example, via termux with a git server, Tasker, python/bash script,).
- You can open `habit.json` in any text editor and make changes — they will be reflected in the app. 
- This project began as a college assignment and quickly became my personal playground for learning Flutter and mobile architecture.
- It’s still in its early (alpha) stages.

---

## Roadmap
- [ ] Sync habits across devices (OneDrive, Dropbox, Google Drive)
- [ ] Support for other platforms (ios, desktop, web)
- [ ] Custom reminders & notifications
- [ ] Adding more visualizations
- [ ] Publish to Google Play & App Store
- [ ] Importing Loop habit tracker data via csv
- [ ] Fixing theme and optmizing/refactoring code
- [ ] and many more :)

---

## Contributing
I’m open to collaborators and maintainers—especially as I explore other projects and technologies. To contribute:

1. Fork this repository
2. Create a feature branch (git checkout -b feature/YourFeature)
3. Commit your changes (git commit -m "Describe your feature")
4. Push to your branch (git push origin feature/YourFeature)
5. Open a Pull Request

## Download

⚠️ **Warning:** This is a very early alpha release (v0.0.1). Expect bugs and incomplete features.

You can download the APK here:   
[📥 Download FLoop Habit Tracker v0.0.1 APK](https://github.com/Anzar-M/floop-habit-tracker/releases/download/v0.0.1/FLoop-Habit-Tracker-v0.0.1.apk)


### About the name

Pronunciation: (/fluːp/) — sounds like "floo-p"

Why “FLoop”?

- Because it’s a **Flutter Loop habit tracker**
- And, well… it *might be a flop* 😅

