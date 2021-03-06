﻿import React, { Component } from 'react'
import { Button, Card } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import '../cards.css'
import { EditButton, DeleteButton } from '../../customButtons'

export class AdminTrainingList extends Component {
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
            redirect: false,
            create: false,
            edit: false,
            delSuccess: false,
            editId: 0,
            trainings: [],
        };

        this.getTrainings()
    }

    getTrainings() {
        fetch('/api/volunteer-trainings', {
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
                    trainings: data.trainings
                })
            }
        })
        .catch((err) => {
            console.log(err)
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
                pathname: '/admin-training-create',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }} />
        }
        else if (this.state.edit) {
            return <Redirect to={{
                pathname: '/admin-training-edit/' + this.state.editId,
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }} />
        }
    }

    renderTrainings = () => {
        if (this.state.trainings != null) {
            const p = this.state.trainings.map((t, index) => {
                return (
                    <div key={index}>
                        <Card style={{ width: '25rem' }}>
                            <Card.Header as='h5'>
                                {t.name}
                            </Card.Header>
                            <Card.Body>
                                <EditButton onButtonClick={this.setEdit} value={t.id} />
                                <DeleteButton onButtonClick={this.onDelete} value={t.id} />
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

    onDelete = (id) => {
        fetch('/api/volunteer-training-delete', {
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
                    trainings: this.state.trainings.filter(t => t.id !== id)
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

                <h1 style={styling.head}>Manage Trainings</h1>

                <Button variant="success" size="lg" style={{ marginLeft: '7%' }} onClick={this.setCreate}>
                    Add Training
                </Button>

                <div style={styling.deckDiv}>
                    {this.renderTrainings()}
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