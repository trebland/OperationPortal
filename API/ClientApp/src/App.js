import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom'
import { Welcome } from './structures/welcome'
import { LoginBox } from './structures/welcomeOptions/LoginBox'
import { GeneralCalendar } from './structures/welcomeOptions/GeneralCalendar'
import { RegisterBox } from './structures/welcomeOptions/RegisterBox'
import { UserDashboard } from './structures/userViews/userDashboard'
import { AdminDashboard } from './structures/adminViews/adminDashboard'
import { UserCalendar } from './structures/userViews/userCalendar/userCalendar'
import { UserAnnouncements } from './structures/userViews/userAnnouncements'
import { NotFound } from './structures/notFound'
import { UserProfile } from './structures/userViews/userProfile'
import { AdminAnnouncements } from './structures/adminViews/adminAnnouncements/adminAnnouncements'
import { ViewVolunteers } from './structures/adminViews/editVolunteers/viewVolunteers'
import { AdminProfile } from './structures/adminViews/adminProfile'
import { AdminCalendar } from './structures/adminViews/calendarFunctions/adminCalendar'
import { ChildrensCalendar } from './structures/adminViews/childrensCalendar'
import { StaffCalendar } from './structures/adminViews/staffCalendar'
import { PrivacyPolicy } from './structures/privacyPolicy'
import { AdminVolunteerEdit } from './structures/adminViews/editVolunteers/adminVolunteerEdit'
import { AdminGetId } from './structures/adminViews/editVolunteers/adminGetId'
import { UserEventDetails } from './structures/userViews/userCalendar/userEventDetails'
import { AdminEventDetails } from './structures/adminViews/calendarFunctions/adminEventDetails'
import { AdminEditEvent } from './structures/adminViews/calendarFunctions/editEvent'
import { AdminBusList } from './structures/adminViews/adminBus/adminBusList'
import { AdminBusCreate } from './structures/adminViews/adminBus/adminBusCreate'
import { AdminBusEdit } from './structures/adminViews/adminBus/adminBusEdit'
import { AdminTrainingList } from './structures/adminViews/adminTraining/adminTrainingList'
import { AdminTrainingCreate } from './structures/adminViews/adminTraining/adminTrainingCreate'
import { AdminTrainingEdit } from './structures/adminViews/adminTraining/adminTrainingEdit'
import { AdminJobList } from './structures/adminViews/adminJob/adminJobList'
import { AdminJobCreate } from './structures/adminViews/adminJob/adminJobCreate'
import { AdminJobEdit } from './structures/adminViews/adminJob/adminJobEdit'
import { AdminClassList } from './structures/adminViews/adminClass/adminClassList'
import { AdminClassCreate } from './structures/adminViews/adminClass/adminClassCreate'
import { AdminClassEdit } from './structures/adminViews/adminClass/adminClassEdit'
import { UserJobDetails } from './structures/userViews/userCalendar/userJobDetails'
import { AdminAllAnnouncements } from './structures/adminViews/adminAnnouncements/adminAllAnnouncements'
import { AdminEditAnnouncements } from './structures/adminViews/adminAnnouncements/adminEditAnnouncements'
import { AdminAddAnnouncements } from './structures/adminViews/adminAnnouncements/adminAddAnnouncements'
import { PasswordResetRequest } from './structures/passwordReset/passwordResetRequest'
import { PasswordResetConfirm } from './structures/passwordReset/passwordResetConfirm'
import { AdminViewGroups } from './structures/adminViews/calendarFunctions/adminViewGroups'
import { AdminAttendingVolunteers } from './structures/adminViews/calendarFunctions/adminAttendingVolunteers'
import { AdminAllAbsences } from './structures/adminViews/calendarFunctions/adminAllAbsences'
import { AdminJobRoster } from './structures/adminViews/calendarFunctions/adminJobRoster'
import { AdminDriverCheckIn } from './structures/adminViews/adminDriver/adminDriverCheckIn'

// http://jquense.github.io/react-big-calendar/examples/index.html#basic

export default class App extends Component {
  static displayName = App.name;

  render () {
    return (
      <div>
        <Router>
          <Switch>
            <Route exact path='/login' component={LoginBox} />
            <Route exact path='/' component={Welcome} />
            <Route exact path='/general-calendar' component={GeneralCalendar} />
            <Route exact path='/signup' component={RegisterBox} />
            <Route exact path='/dashboard' component={UserDashboard} />
            <Route exact path='/admin-dashboard' component={AdminDashboard} />
            <Route exact path='/user-calendar' component={UserCalendar} />
            <Route exact path='/user-announcements' component={UserAnnouncements} />
            <Route exact path='/user-profile' component={UserProfile} />
            <Route exact path='/admin-announcements' component={AdminAnnouncements} />
            <Route exact path='/admin-all-announcements' component={AdminAllAnnouncements} />
            <Route exact path='/admin-volunteer-list' component={ViewVolunteers} />
            <Route exact path='/admin-profile' component={AdminProfile} />
            <Route exact path='/admin-calendar' component={AdminCalendar} />
            <Route exact path='/child-birthday-calendar' component={ChildrensCalendar} />
            <Route exact path='/staff-birthday-calendar' component={StaffCalendar} />
            <Route exact path='/privacy-policy' component={PrivacyPolicy} />
            <Route exact path='/admin-volunteer-edit' component={AdminVolunteerEdit} />
            <Route exact path='/admin-get-id' component={AdminGetId} />
            <Route exact path='/user-event-details' component={UserEventDetails} />
            <Route exact path='/admin-event-details' component={AdminEventDetails} />
            <Route exact path='/admin-event-edit' component={AdminEditEvent} />
            <Route exact path='/admin-bus-list' component={AdminBusList} />
            <Route exact path='/admin-bus-create' component={AdminBusCreate} />
            <Route path='/admin-bus-edit/:id' component={AdminBusEdit}/>
            <Route exact path='/admin-training-list' component={AdminTrainingList} />
            <Route exact path='/admin-training-create' component={AdminTrainingCreate} />
            <Route path='/admin-training-edit/:id' component={AdminTrainingEdit} />
            <Route exact path='/admin-job-list' component={AdminJobList} />
            <Route exact path='/admin-job-create' component={AdminJobCreate} />
            <Route path='/admin-job-edit/:id' component={AdminJobEdit} />
            <Route exact path='/admin-class-list' component={AdminClassList} />
            <Route exact path='/admin-class-create' component={AdminClassCreate} />
            <Route path='/admin-class-edit/:id' component={AdminClassEdit} />
            <Route path='/user-saturday-jobs' component={UserJobDetails}/>
            <Route path='/admin-edit-announcements' component={AdminEditAnnouncements}/>
            <Route path='/admin-add-announcements' component={AdminAddAnnouncements}/>
            <Route path='/password-reset-request' component={PasswordResetRequest}/>
            <Route path='/password-reset-confirm' component={PasswordResetConfirm}/>
            <Route path='/admin-group-details' component={AdminViewGroups}/>
            <Route path='/admin-attending-volunteers' component={AdminAttendingVolunteers}/>
            <Route path='/admin-all-absences' component={AdminAllAbsences}/>
            <Route path='/admin-job-roster' component={AdminJobRoster}/>
            <Route path='/admin-driver-checkin' component={AdminDriverCheckIn}/>

            
            <Route component={NotFound} />
          </Switch>
        </Router>
      
      </div>
      
    );
  }
}
