import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

export class AdminBusEdit extends Component {
    constructor(props) {
        super(props)

        if (props.location.state != null) {
            this.state = {
                jwt: props.location.state.jwt,
                loggedin: props.location.state.loggedin,
                name: '',
                route: '',
                driverName: '',
                redirect: false,
                result: '',
                success: false,
                getSuccess: false,
                driverSuccess: false,
                getDriverSuccess: false,
                driverResult: '',
                newDriverId: 0,
                newDriverName: '',
                drivers: []
            };
            this.handleNameChange = this.handleNameChange.bind(this);
            this.handleRouteChange = this.handleRouteChange.bind(this);
            this.handleDriverChange = this.handleDriverChange.bind(this);
            this.onSubmit = this.onSubmit.bind(this);
            this.onDriverSubmit = this.onDriverSubmit.bind(this);
        }
        else {
            this.state = {
                loggedin: false,
            }
        }

        if (props.match.params.id) {
            this.getBusInfo()
            this.getBusDrivers()
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

    handleRouteChange = (e) => {
        this.setState({
            route: e.target.value
        })
    }

    handleDriverChange = (e) => {
        this.setState({
            newDriverId: e.target.value,
            newDriverName: e.target.selectedOptions[0].text
        })
    }

    // Gets the current information about the bus so that the fields can be prefilled
    getBusInfo = () => {
        fetch('/api/bus-info?id=' + this.props.match.params.id, {
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
                    name: data.bus.name,
                    route: data.bus.route,
                    driverName: data.bus.driverName
                })
            }
        })
    }

    // Gets the list of bus drivers for populating the dropdown
    getBusDrivers() {
        fetch('/api/bus-drivers', {
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            },
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                this.setState({
                    getDriverSuccess: true,
                })
                return res.json()
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                this.setState({
                    getDriverSuccess: false,
                })
                return
            }
        })
        .then((data) => {
            if (this.state.getDriverSuccess) {
                this.setState({
                    drivers: data.drivers
                })
            }
        })
    }

    // Handles submitting the name and route
    onSubmit = (e) => {
        e.preventDefault();

        if (!this.state.name) {
            this.setState({
                success: false,
                result: 'Bus name cannot be empty'
            })
            return
        }

        if (!this.state.name.length > 300) {
            this.setState({
                success: false,
                result: 'Bus name is too long (limit 300 characters)'
            })
        }

        try {
            fetch('/api/route-edit', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.state.jwt}`
                },
                body: JSON.stringify({ Id: this.props.match.params.id, Name: this.state.name, Route: this.state.route })
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

    // Submits the change to the driver for a bus
    onDriverSubmit = (e) => {
        e.preventDefault();

        fetch('/api/bus-driver-assignment', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            },
            body: JSON.stringify({ Id: this.props.match.params.id, DriverId: this.state.newDriverId })
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                this.setState({
                    driverResult: 'Edit saved successfully!',
                    driverSuccess: true,
                })
                return
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                this.setState({
                    driverSuccess: false,
                })
                return res.json()
            }
        })
        .then((data) => {
            if (!this.state.driverSuccess) {
                this.setState({
                    driverResult: data.error
                })
            }
            else {
                this.setState({
                    driverName: this.state.newDriverName
                })
            }
        })
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    renderRedirect = () => {
        if (this.state.redirect) {
            return <Redirect to={{
                pathname: '/admin-bus-list',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }} />
        }
    }

    renderDrivers() {
        if (this.state.drivers != null) {
            const p = this.state.drivers.map((d, index) => {
                return <option key={index} value={d.id}>{d.preferredName || d.firstName} {d.lastName}</option>
            })
            return p;
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
                    <h1>Edit Bus</h1>
                </div>
                <div className="box" style={styling.outerDiv}>
                    <Form style={styling.formDiv}>
                        <FormGroup>
                            <FormLabel>Bus Name</FormLabel>
                            <FormControl type="text" placeholder="Bus Name" value={this.state.name} onChange={this.handleNameChange} />
                        </FormGroup>

                        <FormGroup controlId="formBasicPassword">
                            <FormLabel>Route Description</FormLabel>
                            <Form.Control as="textarea" placeholder="Route Description" value={this.state.route} onChange={this.handleRouteChange} />
                        </FormGroup>
                        <p style={ this.state.success ? { color: 'green' } : { color: 'red'} }>{this.state.result}</p>
                        <div>
                            <center>
                                {this.renderRedirect()}
                                <Button variant="link" variant="primary" size="lg" onClick={this.onSubmit} style={{ justifyContent: 'center' }}>
                                    Save name and route description
                                </Button>
                            </center>
                        </div>
                    </Form>
                    <Form style={styling.formDiv}>
                        <p>Current driver: {this.state.driverName || "Not assigned"}</p>
                        <FormGroup>
                            <FormLabel>New Driver: </FormLabel>
                            <Form.Control as="select" value={this.state.newDriver} onChange={this.handleDriverChange}>
                                <option value={0}>Select a new driver</option>
                                {this.renderDrivers()}
                            </Form.Control>
                        </FormGroup>
                        <p style={this.state.driverSuccess ? { color: 'green' } : { color: 'red' }}>{this.state.driverResult}</p>
                        <div>
                            <center>
                                {this.renderRedirect()}
                                <Button variant="link" variant="primary" size="lg" onClick={this.onDriverSubmit} style={{ justifyContent: 'center' }}>
                                    Save new driver
                                </Button>
                            </center>
                        </div>
                    </Form>
                </div>
                <div className="box" style={styling.outerDiv}>
                    
                </div>
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