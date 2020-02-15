import React, { Component } from 'react';
import { Calendar, momentLocalizer } from 'react-big-calendar'
import moment from 'moment'
import events from './events'
import 'react-big-calendar/lib/css/react-big-calendar.css'

// https://www.npmjs.com/package/react-big-calendar
// http://intljusticemission.github.io/react-big-calendar/examples/index.html#intro

const localizer = momentLocalizer(moment)

export class Home extends Component {

  constructor(props) {
    super(props)
    this.state = {
      username: this.props.username,
      loggedin: false
    }
    console.log(this.state.username)
  }
  
  static displayName = Home.name;

  render () {
    if(this.state.loggedin){
      return (
        <div style={{height: "500px"}}>
        <h1>baldwin</h1>
        <h1>calendar for{(this.state.loggedin) ? "for " + this.state.username : ""}</h1>
        <Calendar
          localizer = {localizer}
          events = {events}
          startAccessor = "start"
          endAccessor = "end"
        />
      </div>
      )
    }
    else{
      return(
        <div style={{height: "500px"}}>
          <h1>calendar</h1>
          <Calendar
            localizer = {localizer}
            events = {events}
            startAccessor = "start"
            endAccessor = "end"
          />
        </div>
      )
    }
  }
}
