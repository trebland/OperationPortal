import React, { Component } from 'react';
import { Calendar, momentLocalizer } from 'react-big-calendar'
import moment from 'moment'
import events from './dummydata/events'
import 'react-big-calendar/lib/css/react-big-calendar.css'
import { Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

// https://www.npmjs.com/package/react-big-calendar
// http://intljusticemission.github.io/react-big-calendar/examples/index.html#intro

const localizer = momentLocalizer(moment)

export class ChildrensCalendar extends Component {

  constructor(props) {
    super(props)
    this.state = {
        jwt: props.location.state.jwt,
        loggedin: props.location.state.loggedin,
        redirect: false
    }
  }

  renderRedirect = () => {
    if(this.state.redirect){
        return <Redirect to={{
            pathname: '/admin-dashboard',
            state: {
                jwt: this.state.jwt,
                loggedin: this.state.loggedin
            }
        }}/>
    }
  }

  setRedirect = () => {
      this.setState({
          redirect: true
      })
  }


  render () {
    return(
        <div>
            <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                Back to Dashboard
            </Button>
            <div style={styling.cal}>
                <h1>Children's Birthday Calendar</h1>
                <Calendar
                    localizer = {localizer}
                    events = {events}
                    startAccessor = "start"
                    endAccessor = "end"
                />
            </div>
            {this.renderRedirect()}
        </div> 
    )
  }
}

const styling = {
    cal: {
        height: '550px',
        padding: '20px 20px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
    }
}


