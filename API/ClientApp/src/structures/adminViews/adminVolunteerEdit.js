import React, { Component } from 'react'
import { Redirect } from 'react-router-dom'
import { Form, FormControl, FormGroup, FormLabel, Button, Col, Row } from 'react-bootstrap/'

export class AdminVolunteerEdit extends Component {
    constructor(props){
        super(props)
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            volunteer: props.location.state.volunteer
        }
        console.log(this.state.volunteer)
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    componentDidMount() {
        this.mounted = true
    }

    componentWillUnmount() {
        this.mounted = false
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

    renderVolunteer = () => {
        const vol = this.state.volunteer
        return (
            <div style={styling.volunteer}>
                <FormGroup>
                    <FormLabel>
                        ID Number:
                    </FormLabel>   
                    <Form.Control plaintext readOnly defaultValue={vol.id} />
                </FormGroup>
                <FormGroup>
                    <FormLabel>
                        Name:
                    </FormLabel>   
                    <Form.Control plaintext readOnly defaultValue={vol.firstName + " " +vol.lastName} />
                </FormGroup>
                <FormGroup>
                    <FormLabel>
                        Orientation:
                    </FormLabel>   
                    <Form.Control plaintext readOnly defaultValue={vol.orientation ? "Yes" : "No"} />
                </FormGroup>
                <FormGroup>
                    <FormLabel>
                        Blue Shirt:
                    </FormLabel>   
                    <Form.Control plaintext readOnly defaultValue={vol.blueShirt ? "Yes" : "No"} />
                </FormGroup>
                <FormGroup>
                    <FormLabel>
                        Name Tag:
                    </FormLabel>   
                    <Form.Control plaintext readOnly defaultValue={vol.nametag ? "Yes" : "No"} />
                </FormGroup>
                <FormGroup>
                    <FormLabel>
                        Personal Interview:
                    </FormLabel>   
                    <Form.Control plaintext readOnly defaultValue={vol.personalInterviewCompleted ? "Yes" : "No"} />
                </FormGroup>
                <FormGroup>
                    <FormLabel>
                        Background Check:
                    </FormLabel>   
                    <Form.Control plaintext readOnly defaultValue={vol.backgroundCheck ? "Yes" : "No"} />
                </FormGroup>
                <FormGroup>
                    <FormLabel>
                        Year Started:
                    </FormLabel>   
                    <Form.Control plaintext readOnly defaultValue={vol.yearStarted} />
                </FormGroup>
                <FormGroup>
                    <FormLabel>
                        Can Edit Inventory:
                    </FormLabel>   
                    <Form.Control plaintext readOnly defaultValue={vol.canEditInventory ? "Yes" : "No"} />
                </FormGroup>
                
            </div>
        )
    }

    

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to View Volunteers
                </Button>
                <div style={styling.outderdiv}>
                    {this.renderVolunteer()}
                    <Form>
                        <fieldset>
                            <Form.Group as={Row}>
                            <Form.Label as="legend" column sm={1}>
                                Orientation
                            </Form.Label>
                            <Col sm={10} style={{marginTop: '7px'}}>
                                <Form.Check
                                type="radio"
                                label="Yes"
                                name="formHorizontalRadios"
                                id="formHorizontalRadios1"
                                />
                                <Form.Check
                                type="radio"
                                label="No"
                                name="formHorizontalRadios"
                                id="formHorizontalRadios2"
                                />
                            </Col>
                            </Form.Group>
                        </fieldset>
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
    },
    volunteer: {

    }
}