import React, { Component } from 'react';
import { Calendar, momentLocalizer } from 'react-big-calendar'
import moment from 'moment'
import 'react-big-calendar/lib/css/react-big-calendar.css'
import { Button, Form } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

// https://www.npmjs.com/package/react-big-calendar
// http://intljusticemission.github.io/react-big-calendar/examples/index.html#intro

const localizer = momentLocalizer(moment)

export class AdminCalendar extends Component {
    constructor(props) {
        super(props)
        this.state = {
            eventsapi: [{}],
            groups: [{}],
            redirect: false,
            redirectEvents: false,
            redirectAdd: false,
            clicked: {},
            jwt: props.location.state.jwt,
            name: '',
            description: '',
            date: ''
        }
        console.log(this.state.jwt)
        this.handleNameChange = this.handleNameChange.bind(this)
        this.handleDescriptionChange = this.handleDescriptionChange.bind(this)
        this.handleDateChange = this.handleDateChange.bind(this)
        this.getInfo()
    }

    getInfo = () => {
        let date = new Date()
        let month = date.getMonth() + 1
        let year = date.getFullYear()
        fetch('/api/calendar?month=' + month + '&year=' + year , {
          // method: 'GET',
          headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json'
            }
        })
        .then((res) => {
            console.log(res.status)
            if((res.status === 200 || res.status === 201) && this.mounted === true){
                console.log('Retrieval successful')
                return res.text()
            }
            else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                console.log('Retrieval failed')
                return
            }
        })
        .then((data) => {
            let res = JSON.parse(data)
            let g = res.groups
            let eve = res.events
            
            let e = eve.map((details) => {
                let year = Number.parseInt(details.date.substring(0, 4))
                // starts at 0 for january 
                let month = Number.parseInt(details.date.substring(5, 7)) 
                let day = Number.parseInt(details.date.substring(8, 10))
                let ret = {
                    id: details.id,
                    year: year,
                    month: month,
                    day: day,
                    'title': details.name,
                    'allDay': true,
                    desc: details.description,
                    'start': new Date(year, month - 1, day),
                    'end': new Date(year, month - 1, day)
                }
                return ret
            })

            if(this.mounted === true){
                this.setState({
                    groups: g,
                    eventsapi: e
                })
            }
        })
        .catch((err) => {
            console.log(err)
        })
    }

    componentWillUnmount = () => {
        this.mounted = false
    }
    
    componentDidMount = () => {
        this.mounted = true
    }
    
    renderRedirect = () => {
        if(this.state.redirect){
            return <Redirect to={{
                pathname: '/admin-dashboard',
                state: {
                    jwt: this.state.jwt
                }
                
            }}/>
        }
        else if(this.state.redirectEvents){
            return <Redirect to={{
                pathname: '/admin-event-details',
                state: {
                    clicked: this.state.clicked,
                    jwt: this.state.jwt
                }
            }}/>
        }
    }

    
    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    getEventDetails = (ep) => {
        console.log(ep.year)
        this.setState({
            clicked: ep,
            redirectEvents: true
        })
        console.log(this.state.clicked)
    }

    handleNameChange = (e) => {
        this.setState({
            name: e.target.value
        })
        console.log(this.state.name)
    }

    handleDescriptionChange = (e) => {
        this.setState({
            description: e.target.value
        })
        console.log(this.state.description)
    }

    handleDateChange = (e) => {
        this.setState({
            date: e.target.value
        })
        console.log(this.state.date)
    }

    callAddEndpoint = (e) => {
        let a = this.state.date
        let year = a.substring(0, 4)
        let month = a.substring(5, 7)
        let day = a.substring(8, 10)
        let nue = year + '-' + month + '-' + day
        try {
            fetch('/api/calendar/event-creation', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`,
                    'Accept': 'application/json'
                },
                body: JSON.stringify({
                    'date': nue,
                    'name': this.state.name,
                    'description': this.state.description
                })
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('add event successful')
                    // reload the page to show new event that has been added
                    window.location.reload(false)
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('add event failed')
                    return
                }
            })
        }
        catch(e){
            console.log('did not connect')
        }
    }

    addEvent = () => {
        return (
            <div style={styling.add}>
                <h2>Add an Event</h2>
                <Form>
                    <Form.Group>
                        <Form.Label>Date</Form.Label>
                        <Form.Control type="date" onChange={this.handleDateChange}/>
                        <Form.Text>
                            Date of Event
                        </Form.Text>
                    </Form.Group>

                    <Form.Group>
                        <Form.Label>Name</Form.Label>
                        <Form.Control type="text" placeholder="Name of Event" onChange={this.handleNameChange}/>
                    </Form.Group>

                    <Form.Group>
                        <Form.Label>Description</Form.Label>
                        <Form.Control type="text" placeholder="Description of Event" onChange={this.handleDescriptionChange}/>
                    </Form.Group>
                    
                    <Button variant="link" variant="primary" size="lg" onClick={this.callAddEndpoint}>
                        Add Event
                    </Button>
                </Form>
            </div>
        )
    }

    render () {

        return(
            <div>
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>
                <div style={styling.cal}>
                    <h1>Admin Calendar</h1>
                    <Calendar
                        selectable
                        popup
                        localizer = {localizer}
                        events = {this.state.eventsapi}
                        startAccessor = "start"
                        endAccessor = "end"
                        onSelectEvent={e => {this.getEventDetails(e)}}
                    />
                    <br></br>
                    {this.addEvent()}
                </div>
                {this.renderRedirect()}
                
                
            </div> 
        )
    }
}

const styling = {
    cal: {
        height: '600px',
        padding: '20px 20px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
    },
    add: {
        marginBottom: '50px'
    }
}