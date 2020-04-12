import React, { Component } from 'react';
import { Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

// https://www.npmjs.com/package/react-big-calendar
// http://intljusticemission.github.io/react-big-calendar/examples/index.html#intro



export class UserEventDetails extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false,
            clicked: props.location.state.clicked,
            year: props.location.state.year,
            month: props.location.state.month,
            day: props.location.state.day,
            details: [{}],
            jwt: props.location.state.jwt
        }
        console.log(this.state.clicked)
        this.getInfo()
    }

    getInfo = () => {
        let year = this.state.clicked.year
        let month = this.state.clicked.month
        let day = this.state.clicked.day
        let date = month + '/' + day + '/' + year
        fetch('/api/calendar/details?date=' + date , {
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
                pathname: '/user-calendar',
                state: {
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

    signupEvent = (ep) => {
        var id = ep.id
        try {
            fetch('api/calendar/signup/event' , {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
                body: JSON.stringify(
                    {
                        eventId: id
                    }
                )
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('event signup successful')
                    this.setState({
                        redirect: true
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('event signup unsuccessful')
                    return
                }
            })

        }
        catch(e) {
            console.log(e)
        }
    }

    cancelEvent = (ep) => {
        var id = ep.id
        try {
            fetch('api/calendar/cancellation/event' , {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
                body: JSON.stringify(
                    {
                        eventId: id
                    }
                )
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('event cancellation successful')
                    this.setState({
                        redirect: true
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('event cancellation unsuccessful')
                    return
                }
            })

        }
        catch(e) {
            console.log(e)
        }
    }

    showEvents = () => {
        if(this.state.details.events != null){
            let eve = this.state.details.events.map((e, index) => {
                return (
                    <div key={index} style={styling.eves}>
                        <h2>{e.name}</h2>
                        <hr></hr>
                        <p>{e.description}</p>
                        <Button variant="primary" size="sm" style={styling.sc} onClick={() => {this.signupEvent(e)}}>
                            Signup for this Event
                        </Button>
                        <Button variant="primary" size="sm" style={styling.sc} onClick={() => {this.cancelEvent(e)}}>
                            Cancel for this Event
                        </Button>
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
                    <h3>Notice</h3>
                    <p>
                        If signup or cancellation is successful, you will be taken back to the calendar. 
                    </p>
                    <br></br>
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
    },
    sc: {
        marginRight: '50px'
    }
}


