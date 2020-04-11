import React, { Component } from 'react'
import { Button, Card } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import '../cards.css'
import { EditButton, DeleteButton } from '../../customButtons'

export class AdminJobList extends Component {
    constructor(props) {
        super(props)

        if (props.location.state == null) {
            this.state = {
                loggedin: false
            }
            return
        }

        this.state = {
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            enabled: false,
            enabledSuccess: false,
            redirect: false,
            create: false,
            edit: false,
            delSuccess: false,
            toggleSuccess: false,
            editId: 0,
            jobs: [],
        };

        this.getJobs()
        this.getEnabled()
    }

    getJobs() {
        fetch('/api/volunteer-jobs', {
            // method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            }
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                return res.json()
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                return
            }
        })
        .then((data) => {
            if (this.mounted === true) {
                this.setState({
                    jobs: data.jobs
                })
            }
        })
        .catch((err) => {
            console.log(err)
        })
    }

    // Checks if volunteer jobs are enabled
    getEnabled() {
        fetch('/api/volunteer-jobs-enabled', {
            // method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            }
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                this.setState({
                    enabledSuccess: true
                })
                return res.json()
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                this.setState({
                    enabledSuccess: false
                })
                return
            }
        })
        .then((data) => {
            if (this.state.enabledSuccess === true) {
                this.setState({
                    enabled: data.enabled
                })
            }
        })
    }

    // Sets variable to false when ready to leave page
    componentWillUnmount = () => {
        this.mounted = false
    }

    // Will set a variable to true when component is fully mounted
    componentDidMount = () => {
        this.mounted = true
    }

    renderRedirect = () => {
        if (this.state.redirect) {
            return <Redirect to={{
                pathname: '/admin-dashboard',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }} />
        }
        else if (this.state.create) {
            return <Redirect to={{
                pathname: '/admin-job-create',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }} />
        }
        else if (this.state.edit) {
            return <Redirect to={{
                pathname: '/admin-job-edit/' + this.state.editId,
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }} />
        }
    }

    renderJobs = () => {
        if (this.state.jobs != null) {
            const p = this.state.jobs.map((j, index) => {
                return (
                    <div key={index}>
                        <Card style={{ width: '25rem' }}>
                            <Card.Header as='h5'>
                                {j.name}
                            </Card.Header>
                            <table style={{marginLeft:'10%', marginRight: '10%', marginTop: '2%'}}>
                                <tbody>
                                    <tr>
                                        <th>Minimum Volunteers: </th>
                                        <td>{j.min}</td>
                                    </tr>
                                    <tr>
                                        <th>Maximum Volunteers: </th>
                                        <td>{j.max}</td>
                                    </tr>
                                </tbody>
                            </table>
                            <Card.Body>
                                <EditButton onButtonClick={this.setEdit} value={j.id} />
                                <DeleteButton onButtonClick={this.onDelete} value={j.id} />
                            </Card.Body>
                        </Card>

                    </div>
                )
            })
            return (
                <div className="row">
                    {p}
                </div>
            )
        }
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    setCreate = () => {
        this.setState({
            create: true
        })
    }

    setEdit = (id) => {
        this.setState({
            edit: true,
            editId: id
        })
    }

    onToggle = () => {
        fetch('/api/volunteer-jobs-toggle', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            }
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                this.setState({
                    toggleSuccess: true,
                })
                return
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                this.setState({
                    toggleSuccess: false,
                })
                return res.json()
            }
        })
        .then((data) => {
            if (!this.state.toggleSuccess) {
                alert("Jobs could not be toggled: " + data.error);
            }
            else {
                this.setState({
                    enabled: !this.state.enabled
                })
            }
        })
    }

    onDelete = (id) => {
        fetch('/api/volunteer-jobs-delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.state.jwt}`
            },
            body: JSON.stringify({ Id: id })
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201) && this.mounted === true) {
                this.setState({
                    delSuccess: true,
                })
                return
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500) && this.mounted === true) {
                this.setState({
                    delSuccess: false,
                })
                return res.json()
            }
        })
        .then((data) => {
            if (!this.state.delSuccess) {
                alert("The delete could not be completed: " + data.error);
            }
            else {
                this.setState({
                    jobs: this.state.jobs.filter(j => j.id !== id)
                })
            }
        })
    }

    render() {
        if (!this.state.loggedin) {
            return <Redirect to={{
                pathname: '/login',
            }} />
        }
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>

                <h1 style={styling.head}>Manage Volunteer Jobs</h1>

                <h2 style={styling.head}>
                    Volunteer jobs are currently: <span style={{ fontWeight: 'bold' }}>{this.state.enabled ? 'ENABLED ' : 'DISABLED '}</span>
                    <Button variant="primary" size="lg" onClick={this.onToggle}>Toggle</Button>
                </h2>

                <Button variant="success" size="lg" style={{ marginLeft: '7%' }} onClick={this.setCreate}>
                    Add Job
                </Button>

                <div style={styling.deckDiv}>
                    {this.renderJobs()}
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
        padding: '20px 20px',
        marginLeft: '75px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px',
        marginBottom: '15px'
    },
    table: {
        height: '400px',
        width: '1000px'
    },
    deckDiv: {
        justifyContent: 'center',
        alignContent: 'center',
        outline: 'none',
        border: 'none',
        overflowWrap: 'normal',
        marginLeft: '7%'
    },
    ann: {
        marginTop: '15px',
        marginRight: '15px',
        marginBottom: '15px'
    },
    right: {
        float: 'right'
    }
}