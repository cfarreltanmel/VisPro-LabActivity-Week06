Section Six - Check Yourself

ok before answering anything i honestly don't know if this section should be written in the README.md file and then be commited or not, but for safe measure im just going to answer the questions here then commit it.

i make a separate directory for service outside of model directory. because what i conclude after arguing with gemini for around 40 minutes about project structuring is that if the directory is inside model directory it will violate SRP. Models directory purpose is to hold data (pure data holder/model files) if we put service (which is the one who fetches data from local/external source like the mock json files or live server) inside model directory, now models directory have 2 jobs which is to hold data models and the service files that fetches data. what should we do to fix the project structuring is to put model, service, and repository directories nested insde a data/core/domain directory. I also don't use repository yet because i read that repository purpose is to tell the app if there is no data on the local cache, it should fetch data from the provided data source (local/external) in my case, i've only used mock json file as my main data source. That's i haven't use repository.

oh and a quick info about missing feature from the app is i forgot to add search query for filtering :'). Mistake on my part but hey rather than risking overdue-ing the assignment, atleast the app is finished right...? (Honestly sorry about ths).

ok on to the question answers:

1. the difference between model, view, and view model is that they have different roles in the app, model is the one that holds data (single source of truth (if i remembered correctly)), view is for displaying the data, and view model is the one who fetch the data from model, process is with logical methods (Business rules), then provide it to view so that it can be displayed.

2. because like in the class example, user can inspect the calculation method then manipulate the overdue date so it returns 0 and the fine is 0.

3. well it checks if similar book type stock is still more than what the user requested to borrow. if yes then proceed if no than reject the request.

4. so that it can be used in different screens dynamically and avoid redundant methods/code writing.

5. difference between them is overdue books is still below the 6 months threshold missing book is above that threshold

6. the app should be updated at viewmodels/library*view_model.dart inside calculateFine method. There is a formula there which is currentWeek * 5000, change it to currentWeek \* 7000 so that the fine for each week per day is rising around 7000 per week overdue.
