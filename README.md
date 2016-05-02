#TopTen

## Authors
* Eui Jin "Jeanie" Jung
* Ruijing Li 

## Purpose
* A top ten list of various aspects nearby in the area, created by users, 
<br>
voted by users.

##Features
* Ability to create handle
* Users can vote on every top ten list to create a holistic top ten
* Users can suggest a top ten topic
* Users can vote on potential top ten topics
* Topic most voted on will be created at the end of the day 

## Control Flow
* First-time users will be asked to create an account
* First-time users will be asked to provide access to location
* First row: New top-ten topic of the day
* Rest of the rows will have top-ten topics with the top item shown
* Users can tap on one of the top-ten to vote
* When user taps on one of the top-ten, they will be presented with 
<br>
table view modally
* Note, the top ten will be highlighted for emphasis
* The new table view will have a top ten list of items for a user to vote on
* The user is limited to add one item to a top-ten list
* User can vote on as many items as he/she wants on a top-ten list
* Tab on the top to access potential top-ten questions
* User can submit one top-ten topic users wants to see, per day
* Users can also vote on as many top-ten topics submitted by others users 
* Note, the top-voted top-ten question will be created at midnight

## Implementation

### Model
* User.Swift
* Topic.Swift
* Item.Swift

### View
* LogInView
* ItemTableView
* TopicTableView
* PotentialTopicTableView

### Controller
* LogInViewController
* ItemTableViewController
* TopicTableViewController
* PotentialTopicTableViewController


## Credits
* Parse for backend storage, so we could save user data, their posts,

