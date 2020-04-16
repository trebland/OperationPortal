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

export class BirthdayCalendar extends Component {
    constructor(props) {
        super(props)
        this.state = {
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            redirect: false,
            volunteerBirthday: [{}],
            childrenBirthday: [{}]
        }
        this.getChildrensBirthdays()
        this.getVolunteerBirthdays()
    }
    
    componentWillUnmount = () => {
        this.mounted = false
    }

    componentDidMount = () => {
        this.mounted = true
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
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

    getVolunteerBirthdays = () => {
        let date = new Date()
        let month = date.getMonth() + 1
        let year = date.getFullYear()
        try {
            fetch('api/birthdays/volunteer?month=' + month , {
            // method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                }
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('Retrieval for volunteer birthday successful')
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('Retrieval for volunteer birthday failed')
                    return res.text()
                }
            })
            .then((data) => {
                // console.log(data)
                var res = JSON.parse(data)
                res = res.birthdays
                console.log('Volunteer: ' + res)
            })
        }
        catch(e) {
            console.log(e)
        }
    }

    getChildrensBirthdays = () => {
        let date = new Date()
        let month = date.getMonth() + 1
        let year = date.getFullYear()
        try {
            fetch('api/birthdays/child?month=' + month , {
            // method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                }
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('Retrieval for childrens birthday successful')
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('Retrieval for childrens birthday failed')
                    return res.text()
                }
            })
            .then((data) => {
                console.log(data)
                var res = JSON.parse(data)
                res = res.birthdays
                console.log(res)
            })
        }
        catch(e) {
            console.log(e)
        }
    }


    render () {
        return(
            <div>
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>
                <div style={styling.cal}>
                    <h1>Birthday Calendar</h1>
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


