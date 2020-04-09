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
            name: '',
            description: '',
            date: ''
        }
        console.log(this.state.event)
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

    callEditEndpoint = () => {
        console.log('hi')
    }


    editEvent = () => {
        return (
            <div style={styling.add}>
                <h1 style={styling.head}>Edit Event</h1>
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


