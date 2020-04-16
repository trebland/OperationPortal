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
            volunteerBirthday: [],
            childrenBirthday: [],
            retrievedC: false,
            retrievedV: false
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
                    this.setState({
                        retrievedV: true
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('Retrieval for volunteer birthday failed')
                    this.setState({
                        retrievedV: false
                    })
                    return res.text()
                }
            })
            .then((data) => {
                if(this.state.retrievedV) {
                    var res = JSON.parse(data)
                    res = res.birthdays
                    this.setState({
                        volunteerBirthday: res
                    })
                    console.log(this.state.volunteerBirthday)
                }
                
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
                    this.setState({
                        retrievedC: true
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('Retrieval for childrens birthday failed')
                    this.setState({
                        retrievedC: false
                    })
                    return res.text()
                }
            })
            .then((data) => {
                if(this.state.retrievedV) {
                    var res = JSON.parse(data)
                    res = res.birthdays
                    var c = res.map((details) => {
                        let year = Number.parseInt(details.date.substring(0, 4))
                        // starts at 0 for january 
                        let month = Number.parseInt(details.date.substring(5, 7)) 
                        let day = Number.parseInt(details.date.substring(8, 10))
                        let date = month + '/' + day + '/' + year
                        let ret = {
                            'title': details.name,
                            'start': new Date(year, month - 1, day),
                            'end': new Date(year, month - 1, day),
                            desc: details.name + 'Birthday: ' + date,
                            children: true,
                            volunteer: false
                        }
                        return ret
                    })

                     
                    
                    this.setState({
                        childrenBirthday: res
                    })
                    console.log(this.state.childrenBirthday)
                }
                
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


