# CP2106 (Orbital) 2022
MugTogether (Team ID: 4261)
Team Members:
Goh Jun How
Goh Kang Yang Eric

Level of Achievement: Apollo

# Resources
Poster: [MT Poster](https://drive.google.com/file/d/1N_L-q6fNreHKvtQJjIQe1YkW3xjwjRpj/view?usp=sharing)

Video: [MT_Video](https://tinyurl.com/mugTogetherFinal)

Worklog: [MT_Worklog](https://tinyurl.com/MugTogether-Project-Log)

Hosted web app: [MT_App](https://mugtogether.web.app)

APK Download: [MT_APK](https://tinyurl.com/26nrjx6m)
(Download the APK and install it on an Android phone or emulator to try out our App!)

Google Drive README: [MT_Better_README](https://docs.google.com/document/d/1XjLPD2tslqJIWTMZLeahUzlBDXSbIO2GQrQZwannnVQ/edit?usp=sharing)

# Motivation
Having gone through a year of university at NUS, we have learnt to adapt to the new learning environment and simultaneously experienced setbacks in our study timetable with the need to constantly improve our study realm. We realised that our endeavour to study for upcoming examinations had been dampened by the immense amount of time spent on trying to recall difficult concepts and questions which we once tackled, or even being anxious about missing out on other foreign concepts. Wouldn’t it be better if we have an application that allows us to record questions and notes as and when we study, share resources with fellow students, and practise on a larger pool of questions? These formulate and motivate the core of our thought process. As such, we wish to improve upon this predicament faced by NUS students by creating an app solution centered on resource management. 

We aim to implement a set of core features that would aid students in preparing for their examinations, by adopting a 3Cs framework - Convenience, Customisability, Collaboration.

Using Flutter as our main source of software development platform and Dart as the programming language, we hope to build on our understanding of Object-oriented programming and improve our knowledge of various other frameworks, for instance, Firebase as a back-end database to link with our front-end application, as well as NUSMods API for added relatability and customisability for NUS students.

After the core features have been implemented successfully on Android, the application can be easily adapted to IOS and the web due to the flexibility of Flutter mechanics. This allows all students to enjoy the benefits of the application, with the enhanced convenience of accessing it on the web on a computer. We believe that this would be a motivation-booster that makes learning and studying for examinations more fruitful.

# Vision
We envision MugTogether as the app students would use for their study revision on a day-to-day basis, where the features are kept simple, easily accessible, and can be used without much hassle, all encapsulating our 3Cs framework.
Convenience - We want to make it easy and seamless for students to record entries of questions and notes as they study and access them anytime and anywhere.
Customisability - Focusing on NUS students, we want to create a platform where students can customise their profile details and question entries according to their modules.
Collaboration - We wish to curate a secure common platform for students of all disciplines to share and access resources.

# User Stories
- As a student, I want to record down questions so that I can look at them on a later date.
- As a student, I want to record down notes along with the question so that I can keep track of my thoughts and revise them at a later date.
- As a student, I want to categorise these questions so that I can find the questions I desire quickly through certain keywords I set.
- As a student, I want to find more questions relating to certain subjects so that I can test my knowledge on it.
- As a student, I want to have a controlled environment to test myself with random questions for a particular subject so that I can improve while being under a pseudo exam condition.
- As a student, I want to discuss questions with fellow users to clarify my doubts so that I can validate my knowledge or seek help for questions I don’t understand.
- As a student, I want a simple user interface to easily navigate to different parts of the app whenever needed so that I can access anything I need with ease.

# Scope of Project
MugTogether is a resource management app targeted at NUS students, where students can curate and manage their collection of questions and notes, as well as access more resources to aid in their revision.

While there already exist ways for students to manage and share their notes, such as Google Drive and Notion, they provide a broader solution for the general public. On the other hand, we wish to focus on a more specific revision-centric solution that is specially curated to cater to the needs of NUS students.

Students can record down entries of questions and notes which can be customised accordingly as they undergo their revision. Students can navigate through the app to access the various features conveniently.

# Features
The finalised features that have been implemented are shown below. Each core features will include:
[Overview] The summary of the features and the rationale behind it.
[List of Functions] What the users can expect to do
[Implementation] How we implemented the functions for this feature
[Limitation] Problems we encountered that resulted in flaws or failure to implement (based on milestone 2’s function list)

## User Profile
[Overview]
This feature is required to enable individuality and customisability, where the user has their own account in the system. This is mostly required by the other features that have to separate the users from each other. For this project, we have decided to limit it to NUS students for a more targeted experience. Due to time constraints of the project, we are unable to implement it for students from other schools (such as JC students, NTU students, etc.).

Public profiles have been implemented for other users to view. From this, we wish to give recognition to the more helpful users in our community and also the opportunity to make friends with each other.

[List of functions]
As per tradition for a profiling and authentication system, the following functions are implemented:
Sign up 
Users are able to create an account for the app, with a custom username. Only NUS emails are allowed and an email verification will be sent to verify the user.
Login 
Users are able to log into the app to use the features within. Users must be verified before being allowed to enter.
Forget password
Users are able to reset their password if he/she were to forget. An email will be sent to the user to guide them through the password resetting procedure.
View profile
Users are able to view their profile details.
Edit profile
Users are able to edit their username or change their password, but cannot change their NUS email. Upon changing any details, users are required to reverify themselves with their old password.
Public profile
Users can view some public details about each other via a discussion room in the QnA forum.

[Implementation]
We have made use of Firebase Authentication feature to handle all the authentication related functions, such as logging in and signing up. Furthermore, we also created a document to store the additional information for our public profile page.

We made careful considerations to preserve the security of our users. The documents holding the additional information only stores information we intend to provide for public view. Security rules have been written such that the users themselves can edit this document, while the rest of the user base can only view.

## MyQuestions
[Overview]
A note storing feature, intended for users to store any questions they have encountered and their thought process for that question. Through this feature, we hope to provide users with a quick and easy way to store, edit and filter their questions to help them through their revision.

Furthermore, we also included markdown support to allow users a way to format their notes, and notes sharing through a PDF file or link so that our users can freely share their ideas with their friends.

[List of Functions]
For this feature, we have come up with the following functions:
Question Overview
Users are able to look at an overview of all the questions that are stored within the user’s collection of questions. From the overview, questions that are incomplete (without any notes written) will be highlighted to show that the question has not been attempted by the user. Each card will only show the question itself for simplicity.
Add question
Users are able to add a question into the collection. Users are required to input the module that their questions are associated with. Tags and thought processes (notes) are optional fields to give the user flexibility to bundle their questions together and tackle the questions at a later time. A privacy checkbox is also implemented to give the user their privacy to whether their questions can be seen in the question bank or not.
View question
Users are able to view their question in more detail, revealing more information such as last modified, their notes, the tags and whether their question can be seen in the question bank.
Edit question
Users are able to update their question in a similar fashion to the add question function. However, users are not able to modify their module.
Delete question
Users are able to delete their questions if they do not want it anymore.
Tagging question
Users are able to bundle their questions through tags. Each question can have multiple tags attached to it.
Filter by Module
Users are able to filter their questions by the modules in the overview. The options available to filter by will be based on whether the user has a question for that module.
Filter by Tags
Users are able to filter their questions by the tags in the overview. The options available to filter by will be based on whether the user has a question for that tag. This filter can be chained with the module filter, however, the options available will not change based on the filtered module.
Note Sharing
Users are able to download a PDF copy of their question and notes or retrieve a link to view it online.
Push to QnA
Users are able to push their question to the QnA forum.
Markdown support
Users are able to format their notes following markdown style.

[Implementation]
The database we used is Firebase Cloud Firestore, where the basic CRUD features of the database are handled. Each question is handled as an object to adopt OOP, with common functions for CRUD. As there is a need to update several different documents at once, we have also utilised the idea of database transaction to maintain atomicity when updating.

For the note sharing function, the URL is crafted by storing the info needed to retrieve it from the database. Information is passed through the router, which sends the user to the correct screen along with the question object.

[Limitation]
Upon reviewing our implementation, we have considered these problems
URL information leak
From the URL link generated, encryption is not used and various data are leaked out to the user. With our limited knowledge in cryptography, we are unable to resolve this problem.
URL manipulation
Following the previous problem, it is possible for malicious users to retrieve questions and notes that are not meant to be shared. However, with the randomised document ID, this problem is slightly mitigated since it is harder to guess which ID is used.
PDF markdown unsupported
Unfortunately, the different packages used for pdf and markdown are incompatible with each other, hence we are unable to render the notes as markdown when saved as a PDF.
DIluted/Tainted Bank
While we have implemented the report button, it currently does nothing as the admin accounts have not been implemented. Even so, manually curating a huge bank of questions may require a lot of manpower, which is a flaw to this idea.

## Question Bank
[Overview]
Students trying to find more questions will find this feature useful. This feature seeks to share the questions that a user stores with everyone else. The choice to share their questions ultimately lies with the user. The user’s very own questions will not appear in the question bank, so as to let them find other questions instead.

It is to note that only the question will be shared with each other. Notes will be kept private to prevent answer sharing and encourage the user to try the question themselves rather than looking straight for answers. Furthermore, notes by other users may be incorrect too. For users who are unable to figure out the solution, we recommend them to pull the question into their own collection first, then ask their tutors in real life, or to ask for hints in the QnA forum. Afterwards, they can note their findings down in the question they saved.

As we have limited control over the users, we have provided them with the function to report questions. Difficulty rating has also been implemented to allow users to rate the questions or gauge how hard the question is.

[List of Functions]
Currently, the users are able to perform the following functions:
Search by Module
Users are able to search for all the public questions for a certain module.
Pull to MyQuestions
Users are able to copy a question they found interesting into their personal collection. They can then modify these questions however they like, adding in their own thought process and tags. These duplicated questions will not show up in the question bank.
Report / Flag
Users are able to report questions for review by the admins. Currently, there is no implementation of any admins.
Difficulty Rating
Users are able to provide other users a gauge of the difficulty of the question, by rating it.

[Implementation]
This feature uses a module list gathered from NUSmods API. To prevent repeated calls to the API, the module list is requested, then stored upon initialisation of the app. The database used is the same as the previous feature, with gathering of data from the database using queries and collection groups.

Reporting and rating are both additional fields for the question document. While reporting might not seem to do anything for now, it can be easily used to pick out questions that have been flagged for reviews by admins.
 
[Limitation]
Upon reviewing our implementation, we have considered this problem.
Lax in Firebase security rule
In order to accommodate rating and reporting of the question, additional fields have to be stored in the same document. This results in having to relax the security such that other users are able to edit the document. A workaround to store information in another document is possible, but requires more Firebase reads which we cannot afford.

Note: Currently, we only have questions available for AC5001 and CS2030S for users to try from.

## Quiz
[Overview]
For students who want to test themselves with questions from the bank, this feature aims to provide a pseudo-quiz environment for them. Questions will be randomly drawn from the question bank for the user to try.

[List of Functions]
For greater customisability by the user, the following functions are implemented:
Quiz::Number of Questions
Users are able to indicate the number of questions they would like to attempt, up to 10 questions per quiz.
Quiz::Timer
Users are able to set a timer (10 min to 1h, 5 min interval) for themselves, which they can start whenever. Upon ending, a sound will be played to indicate to the users their time is up.
Module Selection
Users are able to select modules that they wish to test themselves upon.
View Past Attempts
Users are able to view their past attempts, which consist of the questions and their answers to them, along with the date of their attempt.
Past Attempt::Pull to MyQuestions
Users are able to pull interesting questions from their past attempts into their collection, along with the answers they had on that particular question. They can view and modify the questions from the MyQuestions feature. These questions will not show up on the question bank.
Sharable Quiz
Users can share a seed to allow their friends to try the same set of questions as them.

[Implementation]
The implementation of this feature is similar to that of the question bank, the questions that the quiz pulls are from the bank and the module selection is implemented with the same widget in the question bank. An additional asynchronous timer is implemented to run alongside the quiz if needed.

For a shareable code, it is kept simple as a code to store certain info, where we will parse and pull the information required.

[Limitation]
Upon reviewing the possible options, we have considered this problem.

Difficulty System failed implementation
While the algorithm to retrieve a set of questions centred around a certain difficulty level is not hard, we failed to find an efficient way to reduce the amount of document reads needed. This is particularly crucial as our project runs on the free Spark plan, which has a low limit of 50,000 reads per day. Furthermore, we feel that it is also not right to ignore questions that have not been rated by users yet.
Code manipulation
As a side effect similar to URL manipulation, the code is unencrypted and can easily be manipulated to retrieve other users' quiz attempts. 

Note: Currently, we only have questions available for AC5001 and CS2030S for users to try from.

## QnA Forum
[Overview]
Students facing difficulties in their question can use this feature to seek help from the other users on the platform. Here, the user will be able to create a discussion around a question, much like StackOverflow.

[List of Functions]
These functions have been implemented:
Help Posting
Users are able to post questions that they require assistance in.
Module Filter & “Lounges”
Users are able to enter a lounge and look at the discussions pertaining to their module.
Discussion
Users are able to freely partake in a discussion and obtain real time updates for it.

[Implementation]
For this feature, a new database is required. However, we are unable to have 2 firestore databases in the same project, therefore we have created a smaller collection in the database for this feature.

[Limitation]
Upon reviewing the possible options, we have considered this problem.
Auto Save failed implementation
This function is very doable using Firebase Cloud Functions to schedule a task that will be activated a certain time later. However, the pricing plan of our project will have to be upgraded to Blaze plan (pay as you use). While it will still be free, we are unwilling to take the risk that we might incur a debt from exceeding any limits from Firestore or this Cloud Function itself.
An alternative solution we have considered is to use cron jobs to clean up the database everyday, removing discussions that have exceeded the timing. However, we do not have time to implement this.

Note: Currently, we only have discussions available for AC5001 and CS2030S for users to try from.

## User Interface
Following some feedback from Milestone 2, we have improved upon our app’s user interface (UI) and user experience (UX) in general. Some notable changes are written below.

We have defined the requirements for a strong password when first creating the app or when changing the password (at least 1 lowercase letter, 1 uppercase letter, 1 digit, 1 symbol, and minimally 8 characters long).
We have re-worked the implementation of the quiz such that users are unable to submit an incomplete quiz. We have added the module name to all the relevant screens in the quiz as well.
We have made the checkboxes clearer, such as for privatising questions when adding a question in MyQuestions or enabling a timer in Quiz.

Most notably, we have incorporated responsive design in most of the screens in the app. Users may try it by accessing our hosted web app on a monitor screen for better experience, through dragging the screen to minimise it. The size of each widget may change to adapt to the screen width and height. This ensures beauty and consistency in the app design throughout various devices, from a phone to a computer. Users may also test the app’s design on multiple devices for further experience.

Do let us know if you have any suggestions for further improvements on our app’s design!

# Development Plan
For Milestone 2, we held weekly discussions and followed a waterfall developmental approach for our app development, which will be further elaborated on under “Software Engineering Practices”. We have summarised the tasks and features which we have completed and implemented respectively in Milestone 1 and 2, as well as more which we plan to complete and implement respectively by Milestone 3.

## Milestone 1: Ideation
1. Finalised proposal for lift-off
2. General app layout plan
3. Picked up necessary tech - Flutter, Dart, Firebase
User Profile
4. Custom profile: User authentication, account creation (e.g. logging in, register)
MyQuestions
5. Basic CRUD for the users to interact with the database


## Milestone 2: MVP
User Profile
1. Limited to NUS emails
2. Implemented email verification and “forgot password”
MyQuestions
3. Finished the update function for CRUD
4. Implemented tags for each question created and filter for the tags
5. Implemented privacy checkbox
Question Bank
6. Implemented module searching function
7. Implemented function that pulls question from bank to personal storage
Quiz
8. Implemented the quiz feature which generates questions drawn from the question bank and optionally runs on a timer
9. Implemented function that saves quiz attempts which can be accessed
10. Implemented function that pulls question from past quiz attempts to personal storage
User Interface
11. Implemented a nice user interface for all screens of the app
Integration of features
12. Put everything together under a working system
Testing and debugging
13. Mainly manual testing and a bit of integration testing of the app to ensure all aspects and features are working as expected with minimal bugs

## Milestone 3: Extra
User Profile
1. Added more fields like bio and profile picture url for users to better customise their profile
2. Implemented public profile view displaying information including profile picture, username and bio.
MyQuestions
3. Implemented note-sharing function via URL and PDF
4. Implemented markdown support
5. Implemented function that can push questions to QnA forum for discussion with other users
Question Bank
6. Implemented a difficulty rating system of questions
7. Implemented reporting function for users to flag “troll” entries
Quiz
8. Implemented function for users to share code of quiz attempts so that other users get try the same set of questions
QnA Forum
9. Implemented standard module filter
10. Implemented function that can help users post questions for discussion with other users
11. Implemented lounge displaying the discussion rooms available for the selected module
12. Implemented discussion rooms allowing for real-time discussions between users
User Interface
13. Improved the user interface
Integration of features
14. Put everything together under a working system
Testing and debugging
15. Manual testing, plus more integration and automated testing to clean up bugs

## Splashdown:
User Interface/User Experience
1. Improve on UI/UX
Testing and debugging
2. Clean up bugs and improve performance

# Software Engineering Practices

## Git/GitHub version control
The team employs the use of Git and several features of GitHub to enable collaboration and version control of the project. Features we used include features branching, pull requests and issues.

Commit branches are used to segregate different features, allowing us to work separately on different branches without interfering with each other. Furthermore, testing can be done more specifically towards a certain feature. Branches will be merged whenever necessary as there are some components of each feature that interfere with each other, such as QuestionBank relying on MyQuestions.

Pull Requests are mainly used when merging branches into the master branch, which are mostly done when the functions are fully implemented for the feature for MVP. Another merging takes place when the user interfaces for all the screens under the feature are completed. Here, any merge conflicts will be settled and left for the other teammate to code review and accept the merge.

Any bugs that are found while testing will be opened as a GitHub issue, which notifies the other about them. This facilitates discussion for potential solutions if necessary, and easier tracking of the problems that are needed to be resolved.

## Development approach
The team follows similarly to a waterfall developmental approach, with some parts modified due to having a small team. As part of this approach, we curated our features based on the user stories listed above, which helps to anchor our features with the goals intended. A weekly discussion is held to keep track of each other's progress and guide the week ahead on the features to be implemented as development cycles. A simple kanban board is used to track these, alongside an overview on what has to be done to deliver a bug-free MVP.

## Diagrams
- Activity UML diagram
We have created an activity UML diagram, presented below, to clearly showcase the features and routings of the app for users for Milestone 3. Users can refer to it to have a better understanding of how the app works. A clearer zoomable version can be accessed here: [MT UML](https://drive.google.com/file/d/1olxwbs5SPmJm82LT5gJpURyqW41XM9xk/view?usp=sharing).

- Figma Diagram
In order to implement our UI and have a rough idea of how our app will look like, we have created a Figma diagram depicting the different screens and how buttons will interact. This has been updated for Milestone 3.
The interactive version can be accessed with this link: [MT_Figma](https://www.figma.com/file/TXsAeuoWs7dknOoCkFejgl/MugTogether-Prototype?node-id=0%3A1).

- Database schema
To be viewed in the google drive

# Testing
For testing, we have employed several methods to gauge the suitability and correctness of our app.

## Manual
For manual testing, we have tested our app using end-to-end and focus group testing. While implementing the functions, we individually tested each function to ensure it returns the correct output as intended. Once the codes are bug-free, we post a pull request on github for us to peer review the codes and conduct end-to-end testing.

End-to-end testing is conducted by looking through a checklist of the functions that are implemented and simulating how a user would look and feel. Any bugs found will be informed to the person who implemented it. Furthermore, we also attempt to create edge cases to test our system and check for any exception such as pixel overflow on the UI.

We have also recruited some friends, who are NUS students, to test out our app and ask for their feedback. This way, we can understand if our features have accomplished our aim, while finding any faults we have missed along the way.

## Automated
End-to-end testing is also conducted using the flutter integration test. We have coded the driver to run through a series of actions the user will typically do. The driver follows the instructions and notify us of any exception that occurs.

As of now, we have implemented test cases for all the features main functions, with the exception of the question bank as it relies heavily on collaboration. All the test cases have passed the automated testing.

## Evaluation
To evaluate our app, we have decided to base it on the user stories which we have come up with and whether they have been satisfied, if so how well.

As a student, I want to record down questions so that I can look at them on a later date.
Satisfied: Users can take down questions and come back to it again to view and write some notes.
As a student, I want to record down notes along with the question so that I can keep track of my thoughts and revise them at a later date.
Satisfied: Users can take down questions and notes at the same time before saving. Markdown text is also now supported.
As a student, I want to categorise these questions so that I can find the questions I desire quickly through certain keywords I set.
Satisfied: For every question entry, users will have to select a module and can choose to include tags of preference. After adding the entry, users can filter to find it based on the module and tags.
As a student, I want to find more questions relating to certain subjects so that I can test my knowledge on it.
Satisfied: Users can access the question bank to search for questions of their desired module.
As a student, I want to have a controlled environment to test myself with random questions for a particular subject so that I can improve while being under a pseudo exam condition.
Satisfied: Users can access the quiz feature and select a module, number of questions to test themselves on, with the option of enabling a timer. Random questions will then be generated from the question bank.
As a student, I want to discuss questions with fellow users to clarify my doubts so that I can validate my knowledge or seek help for questions I don’t understand.
Satisfied: Users can access the QnA Forum feature and post their questions for a selected module to discuss with other users.
As a student, I want a simple user interface to easily navigate to different parts of the app whenever needed so that I can access anything I need with ease.
Satisfied: Users can access each feature of the app easily via the navigation drawer, with an easy-to-understand interface without the need for much guidance

As mentioned above, we have also engaged our NUS friends to test our app and provide their valuable feedback. Overall, based on the feedback given and our testing, we believe that our app offers a simple and seamless experience for users to enjoy the benefits of the various features which the app caters, albeit some UI limitations. Particularly, the addition of the QnA Forum feature improves upon the versatility of the app since it utilises other features and enhances user experience, making it easier for users to discuss questions on a shared platform.

# Clarifications
Based on the feedback given in Milestone 2, we realised that some of you were confused by the implementation of some features, and would like to offer clarifications.
MyQuestions: When a user adds a question to their personal storage and does not privatise it (via the checkbox), the question will be available for everyone else with an account to see in the question bank (which excludes the user). This is to ensure that the user is not able to add the same question which they have already created.
MyQuestions: If a user adds a question without any notes, the entry will be displayed in pink, which indicates to the user that they have not written any notes or pointers for that question, serving as a reminder for the user to go back to it later.
Quiz: The quiz feature offers a way for users to tackle questions taken from the bank, with the choice of being under time condition. There are no set answers for each question as each question is created by a certain other user, and if users are unsure of how to approach a particular question even after the quiz, they may post it on the QnA forum to discuss with other users.

# Tech Stack
Flutter for frontend app development and testing
Firebase for backend, database and hosting services
Git & GitHub for version control
Visual Studio Code for coding and testing
