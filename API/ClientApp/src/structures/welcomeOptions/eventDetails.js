import React, { Component } from 'react';
import { Calendar, momentLocalizer } from 'react-big-calendar'
import moment from 'moment'
import events from './dummydata/events'
import 'react-big-calendar/lib/css/react-big-calendar.css'
import { Button, Popover, OverlayTrigger } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

// https://www.npmjs.com/package/react-big-calendar
// http://intljusticemission.github.io/react-big-calendar/examples/index.html#intro

const localizer = momentLocalizer(moment)

export class EventDetails extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false,
            clicked: props.location.state.clicked,
            year: props.location.state.year,
            month: props.location.state.month,
            day: props.location.state.day
        }
        console.log(this.state.clicked)
        this.getInfo()
    }

    getInfo = () => {
        let year = this.state.clicked.year
        let month = this.state.clicked.month
        let day = this.state.clicked.day
        let date = day + '/' + month + '/' + year
        console.log(date)
        fetch('http://localhost:5000/api/calendar/details' , {
          // method: 'GET',
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json'
            },
            body: {
                date: date
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
            console.log('hi')
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
                pathname: '/general-calendar'
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
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Calendar
                </Button>
                
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
    }
}


