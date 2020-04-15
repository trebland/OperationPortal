import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import { VolunteerSearch } from '../volunteerSearch'

export class AdminClassEdit extends Component {
    constructor(props) {
        super(props)

        if (props.location.state != null) {
            this.state = {
                jwt: props.location.state.jwt,
                loggedin: props.location.state.loggedin,
                name: '',
                location: '',
                teacherId: 0,
                teacherName: '',
                redirect: false,
                result: '',
                success: false,
                getSuccess: false,
                showModal: false
            };
            this.handleNameChange = this.handleNameChange.bind(this);
            this.onSubmit = this.onSubmit.bind(this);
        }
        else {
            this.state = {
                loggedin: false,
            }
        }

        if (props.match.params.id) {
            this.getTrainingInfo()
        }
    }

    componentDidMount() {
        this.mounted = true
    }

    handleNameChange = (e) => {
        this.setState({
            name: e.target.value
        })
    }

    handleLocationChange = (e) => {
        this.setState({
            location: e.target.value
        })
    }

    handleClose = () => {
        this.setState({
            showModal: false
        })
    }

    handleSelect = (id, name) => {
        this.setState({
            teacherId: id,
            teacherName: name,
            showModal: false
        })
    }

    showModal = (e) => {
        e.preventDefault();
        this.setState({
            showModal: true
        })
    }

    // Gets the current information about the training so that the fields can be prefilled
    getTrainingInfo = () => {
        fetch('/api/class-info?id=' + this.props.match.params.id, {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            },
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                this.setState({
                    getSuccess: true,
                })
                return res.json()
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                this.setState({
                    getSuccess: false,
                })
                return
            }
        })
        .then((data) => {
            if (this.state.getSuccess) {
                this.setState({
                    name: data.class.name,
                    location: data.class.location,
                    teacherId: data.class.teacherId,
                    teacherName: data.class.teacherName
                })
            }
        })
    }

    onSubmit = (e) => {
        e.preventDefault();

        if (!this.state.name) {
            this.setState({
                success: false,
                result: 'Training name cannot be empty'
            })
            return
        }

        if (!this.state.teacherId) {
            this.setState({
                success: false,
                result: 'Must select a teacher'
            })
        }

        try {
            fetch('/api/class-edit', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
                body: JSON.stringify({Id: this.props.match.params.id, Name: this.state.name, Location: this.state.location, TeacherId: this.state.teacherId})
            })
            .then((res) => {
                if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                    this.setState({
                        result: 'Edit saved successfully!',
                        success: true,
                    })
                    return
                }
                else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                    this.setState({
                        success: false,
                    })
                    return res.json()
                }
            })
            .then((data) => {
                if (!this.state.success) {
                    this.setState({
                        result: data.error
                    })
                }
            })
        }
        catch (e) {
            console.log(e);
        }
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    renderRedirect = () => {
        if (this.state.redirect) {
            return <Redirect to={{
                pathname: '/admin-class-list',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }} />
        }
    }

    render() {
        if (!this.state.loggedin) {
            return <Redirect to={{
                pathname: '/login',
            }} />
        }
        if (!this.props.match.params.id || !this.state.getSuccess) {
            return (
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to List
                </Button>
            )
        }
        return (
            <div>
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to List
                </Button>
                <div style={styling.header}>
                    <h1>Edit Class</h1>
                </div>
                <div className="box" style={styling.outerDiv}>
                    <Form style={styling.formDiv}>
                        <FormGroup>
                            <FormLabel>Class Name</FormLabel>
                            <FormControl type="text" placeholder="Class Name" value={this.state.name} onChange={this.handleNameChange} />
                        </FormGroup>
                        <FormGroup>
                            <FormLabel>Class Location</FormLabel>
                            <FormControl type="text" placeholder="Class Location" value={this.state.location} onChange={this.handleLocationChange} />
                        </FormGroup>
                        <p style={{ display: 'inline' }}><span style={{ fontWeight: 'bold' }}>Teacher: </span> {(this.state.teacherName || 'None selected') + ' '} </p>
                        <Button variety="primary" onClick={this.showModal}>Change</Button>
                        <p style={this.state.success ? { color: 'green' } : { color: 'red' }}>{this.state.result}</p>
                        <div>
                            <center>
                                {this.renderRedirect()}
                                <Button variant="link" variant="primary" size="lg" onClick={this.onSubmit} style={{ justifyContent: 'center' }}>
                                    Save
                                </Button>
                            </center>
                        </div>
                    </Form>
                </div>
                <VolunteerSearch show={this.state.showModal} onClose={this.handleClose} onSelect={this.handleSelect} jwt={this.state.jwt} />
            </div>
        );
    }
}

const styling = {
    formDiv: {
        width: '40%',
        margin: '5%'
    },
    outerDiv: {
        display: 'flex',
        justifyContent: 'center',
        margin: '8%',
        marginBottom: '2%'
    },
    header: {
        textAlign: 'center',
        justifyContent: 'center',
        marginTop: '40px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
    }
}