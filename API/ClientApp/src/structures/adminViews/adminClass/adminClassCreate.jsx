import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import { VolunteerSearch } from '../volunteerSearch'

export class AdminClassCreate extends Component {
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
                showModal: false
            };
            this.handleNameChange = this.handleNameChange.bind(this)
            this.onSubmit = this.onSubmit.bind(this);
        }
        else {
            this.state = {
                loggedin: false
            }
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

    onSubmit = (e) => {
        e.preventDefault();

        if (!this.state.name) {
            this.setState({
                success: false,
                result: 'Name is required'
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
            fetch('/api/class-creation', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
                body: JSON.stringify({Name: this.state.name, Location: this.state.location, TeacherId: this.state.teacherId})
            })
            .then((res) => {
                if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                    this.setState({
                        result: 'Added the new class successfully!',
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
                else {
                    this.setState({
                        name: '',
                        location: '',
                        teacherName: '',
                        teacherId: 0
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
        return (
            <div>
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to List
                </Button>
                <div style={styling.header}>
                    <h1>Create Class</h1>
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
                        <p style={ this.state.success ? { color: 'green' } : { color: 'red'} }>{this.state.result}</p>
                        <div>
                            <center>
                                {this.renderRedirect()}
                                <Button variant="link" variant="primary" size="lg" onClick={this.onSubmit} style={{ justifyContent: 'center' }}>
                                    Create
                                </Button>
                            </center>
                        </div>
                    </Form>
                </div>
                <VolunteerSearch show={this.state.showModal} onClose={this.handleClose} onSelect={this.handleSelect} jwt={this.state.jwt}/>
            </div>
        );
    }
}

const styling = {
    formDiv: {
        width: '50%',
    },
    outerDiv: {
        display: 'flex',
        justifyContent: 'center',
        margin: '8%'
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