import React, { Component } from 'react'
import { Redirect } from 'react-router-dom'
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'

export class AdminVolunteerEdit extends Component {
    constructor(props){
        super(props)
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            id: null,
            ori: false
        }
        console.log(this.state.id)
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    renderRedirect = () => {
        if(this.state.redirect){
            return (
                <Redirect to={{
                    pathname: '/admin-volunteer-list',
                    state: {
                        jwt: this.state.jwt,
                        loggedin: this.state.loggedin
                    }
                }}/>
            )
        }
    }

    handleIdChange = (e) => {
        this.setState({
            id: e.target.value
        })
        console.log(this.state.id)
    }

    handleOriChangeTru = (e) => {
        this.setState({
            ori: true
        })
        console.log(this.state.ori)
    }

    handleOriChangeFal = (e) => {
        this.setState({
            ori: false
        })
        console.log(this.state.ori)
    }

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to View Volunteers
                </Button>
                <div style={styling.outderdiv}>
                    <Form>
                        <FormGroup>
                            <FormLabel>
                                ID Number
                            </FormLabel>
                            <FormControl type="number" placeholder="Enter Unique ID Number" value={this.state.id} onChange={this.handleIdChange} />
                        </FormGroup>

                        <FormGroup>
                            <FormLabel>
                                Orientation
                            </FormLabel>
                            <Form.Check type="checkbox" label="Yes" onChange={this.handleOriChangeTru}/>
                            <Form.Check type="checkbox" label="No" onChange={this.handleOriChangeFal}/>
                        </FormGroup>
                        


                    </Form>
                </div>

            </div>
        )
    }
}

const styling = {
    head: {
        marginBottom: "15px",
        textAlign: "center"
    },
    outderdiv: {
        padding: '20px 20px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px',
        marginBottom: '15px'
    }
}