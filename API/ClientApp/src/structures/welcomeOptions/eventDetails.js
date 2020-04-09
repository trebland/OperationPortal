import React, { Component } from 'react';
import { Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

// https://www.npmjs.com/package/react-big-calendar
// http://intljusticemission.github.io/react-big-calendar/examples/index.html#intro



export class EventDetails extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false,
            clicked: props.location.state.clicked,
            year: props.location.state.year,
            month: props.location.state.month,
            day: props.location.state.day,
            details: [{}]
        }
        console.log(this.state.clicked)
        this.getInfo()
    }

    getInfo = () => {
        let year = this.state.clicked.year
        let month = this.state.clicked.month
        let day = this.state.clicked.day
        let date = month + '/' + day + '/' + year
        // https://www.operation-portal.com/api/calendar/details?date=' + date
        // http://localhost:5000/api/calendar/details?date=' + date
        fetch('https://www.operation-portal.com/api/calendar/details?date=' + date , {
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
            if(this.mounted === true) {
                this.setState({
                    details: res
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
                pathname: '/general-calendar'
            }}/>
        }
    }

    
    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    showEvents = () => {
        if(this.state.details.events != null){
            let eve = this.state.details.events.map((e, index) => {
                return (
                    <div key={index} style={styling.eves}>
                        <h2>{e.name}</h2>
                        <hr></hr>
                        <p>{e.description}</p>
                    </div>
                )
            })
            return eve

        }
    }


    render () {
        let year = this.state.clicked.year
        let month = this.state.clicked.month
        let day = this.state.clicked.day
        let date = month + '/' + day + '/' + year

        return(
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Calendar
                </Button>
                <h1 style={styling.head}>All events on {date}</h1>
                <div style={styling.outerdiv}>
                    {this.showEvents()}
                </div>
                
                
            </div> 
        )
    }
}

const styling = {
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
    },
    head: {
        marginBottom: "15px",
        textAlign: "center"
    },
    outerdiv: {
        padding: '20px 20px',
        marginLeft: '75px',
        marginRight: '75px'
    },
    eves: {
        marginBottom: '75px'
    }
}

