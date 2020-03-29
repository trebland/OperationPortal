import React, { Component } from 'react'
// import Form from 'react-bootstrap/Form'
import { Button, Form, Col, Row } from 'react-bootstrap'
import { Redirect } from 'react-router-dom'

export class AdminProfile extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirectDash: false,
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin
        }
    }

    setRedirectDash = () => {
        this.setState({
            redirectDash: true
        })
    }

    renderRedirect = () => {
        if(this.state.redirectDash) {
            return <Redirect to={{
                    pathname: '/admin-dashboard',
                    state: {
                        jwt: this.state.jwt,
                        loggedin: this.state.loggedin
                    }
                }}
            />
        }
    }

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectDash}>
                    Back to Dashboard
                </Button>

                <div style={styling.header}>
                    <h1>Edit Profile</h1>
                </div>

                <div style={styling.form}>
                <Form>
                    <Form.Row>
                        <Form.Group as={Col}>
                        <Form.Label>First Name</Form.Label>
                        <Form.Control type="text" placeholder="First Name" />
                        </Form.Group>

                        <Form.Group as={Col}>
                        <Form.Label>Last Name</Form.Label>
                        <Form.Control type="text" placeholder="Last Name" />
                        </Form.Group>

                        <Form.Group as={Col}>
                        <Form.Label>Preferred Name</Form.Label>
                        <Form.Control type="text" placeholder="Preferred Name" />
                        </Form.Group>
                    </Form.Row>

                    <Form.Row>
                        <Form.Group as={Col}>
                        <Form.Label>Email</Form.Label>
                        <Form.Control type="email" placeholder="Email" />
                        </Form.Group>

                        <Form.Group as={Col}>
                        <Form.Label>Phone Number</Form.Label>
                        <Form.Control type="number" placeholder="###-###-####" />
                        </Form.Group>

                    </Form.Row>

                    <br/>

                    <Form.Row>
                        <Form.Group style={{marginRight: "50px"}}>
                            <Form.Check type="checkbox" label="Orientation" />
                        </Form.Group>
                        
                        <Form.Group style={{marginRight: "50px"}}>
                            <Form.Check type="checkbox" label="Contact When Short" />
                        </Form.Group>

                        <Form.Group style={{marginRight: "50px"}}>
                            <Form.Check type="checkbox" label="Background Check" />
                        </Form.Group>

                        <Form.Group style={{marginRight: "50px"}}>
                            <Form.Check type="checkbox" label="Blue Shirt" />
                        </Form.Group>

                        <Form.Group style={{marginRight: "50px"}}>
                            <Form.Check type="checkbox" label="Name Tag" />
                        </Form.Group>
                    </Form.Row>

                    

                    {/* <Form.Group controlId="formGridAddress1">
                        <Form.Label>Address</Form.Label>
                        <Form.Control placeholder="1234 Main St" />
                    </Form.Group> */}


                    {/* <Form.Row>
                        <Form.Group as={Col} controlId="formGridCity">
                        <Form.Label>City</Form.Label>
                        <Form.Control />
                        </Form.Group>

                        <Form.Group as={Col} controlId="formGridState">
                        <Form.Label>State</Form.Label>
                        <Form.Control as="select" value="Choose...">
                            <option>Choose...</option>
                            <option>...</option>
                        </Form.Control>
                        </Form.Group>

                        <Form.Group as={Col} controlId="formGridZip">
                        <Form.Label>Zip</Form.Label>
                        <Form.Control />
                        </Form.Group>
                    </Form.Row> */}

                    <br/>

                    <Button variant="primary" type="submit">
                        Submit
                    </Button>
                </Form>
                </div>
            </div>
        )
    }
}

const styling = {
    head: {
        textAlign: "center"
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px',
        marginBottom: '15px'
    },
    header: {
        textAlign: 'center',
        justifyContent: 'center',
        marginTop: '40px'
    },
    form: {
        padding: '20px 20px'
    }
}