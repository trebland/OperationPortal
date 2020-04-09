import React, { Component } from 'react';
import { Button, Form } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

// https://www.npmjs.com/package/react-big-calendar
// http://intljusticemission.github.io/react-big-calendar/examples/index.html#intro



export class AdminEditEvent extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
            event: props.location.state.event,
            clicked: props.location.state.clicked,
            name: '',
            description: '',
            date: '',
            redirectED: false
        }
        console.log(this.state.clicked)
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
                pathname: '/admin-calendar',
                state: {
                    jwt: this.state.jwt
                }
            }}/>
        }
        else if(this.state.redirectED){
            return <Redirect to={{
                pathname: '/admin-event-details',
                state: {
                    jwt: this.state.jwt,
                    clicked: this.state.clicked
                }
            }}/>
        }
    }
    
    setRedirect = () => {
        this.setState({
            redirect: true
        })
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

    callEditEndpoint = (e) => {
        let a = this.state.date
        let year = a.substring(0, 4)
        let month = a.substring(5, 7)
        let day = a.substring(8, 10)
        let nue = year + '-' + month + '-' + day
        console.log(nue)
        // https://www.operation-portal.com/api/calendar/event-edit
        // http://localhost:5000/api/calendar/event-edit
        try {
            fetch('https://www.operation-portal.com/api/calendar/event-edit', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`,
                    'Accept': 'application/json'
                },
                body: JSON.stringify({
                    'id': this.state.event.id,
                    'date': nue,
                    'name': this.state.name,
                    'description': this.state.description
                })
            })
            .then((res) => {
                console.log(res.status)
                if((res.status === 200 || res.status === 201) && this.mounted === true){
                    console.log('edit event successful')
                    this.setState({
                        redirectED: true
                    })
                    return res.text()
                }
                else if((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true){
                    console.log('edit event failed')
                    return
                }
            })
        }
        catch(e){
            console.log('no')
        }
    }

    editEvent = () => {
        let a = this.state.event.date
        let year = a.substring(0, 4)
        let month = a.substring(5, 7)
        let day = a.substring(8, 10)
        let nue = month + '/' + day + '/' + year
        return (
            <div style={styling.add}>
                <h1 style={styling.head}>Edit Event</h1>
                <Form>
                    <Form.Group>
                        <Form.Label>Date</Form.Label>
                        <Form.Control type="date" onChange={this.handleDateChange}/>
                        <Form.Text>
                        Original: {nue}
                        </Form.Text>
                    </Form.Group>

                    <Form.Group>
                        <Form.Label>Name</Form.Label>
                        <Form.Control type="text" placeholder="Name of Event" onChange={this.handleNameChange}/>
                        <Form.Text>
                            Original: {this.state.event.name}
                        </Form.Text>
                    </Form.Group>

                    <Form.Group>
                        <Form.Label>Description</Form.Label>
                        <Form.Control type="text" placeholder="Description of Event" onChange={this.handleDescriptionChange}/>
                        <Form.Text>
                            Original: {this.state.event.description}
                        </Form.Text>
                    </Form.Group>
                    
                    <Button variant="link" variant="primary" size="lg" onClick={this.callEditEndpoint}>
                        Update Event
                    </Button>
                </Form>
            </div>
        )
    }

    
    render () {

        return(
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Calendar
                </Button>
                <div style={styling.outerdiv}>
                    {this.editEvent()}
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
    add: {
        marginBottom: '50px'
    }
}


