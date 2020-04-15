import React, { Component } from 'react'
import { Button, Card } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import '../cards.css'
import { EditButton, DeleteButton } from '../../customButtons'

export class AdminClassList extends Component {
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
            classes: [],
        };

        this.getClasses();
    }

    getClasses() {
        fetch('/api/class-list', {
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
                    classes: data.classes
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
                pathname: '/admin-class-create',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }} />
        }
        else if (this.state.edit) {
            return <Redirect to={{
                pathname: '/admin-class-edit/' + this.state.editId,
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }} />
        }
    }

    renderClasses = () => {
        if (this.state.classes != null) {
            const p = this.state.classes.map((c, index) => {
                return (
                    <div key={index}>
                        <Card style={{ width: '25rem' }}>
                            <Card.Header as='h5'>
                                {c.name}
                            </Card.Header>
                            <Card.Body>
                                <table>
                                    <tbody>
                                        <tr>
                                            <th>Location: </th>
                                            <td>{c.location || 'None'}</td>
                                        </tr>
                                        <tr>
                                            <th>Teacher: </th>
                                            <td>{c.teacherName}</td>
                                        </tr>
                                    </tbody>
                                </table>
                                <EditButton onButtonClick={this.setEdit} value={c.id} />
                                <DeleteButton onButtonClick={this.onDelete} value={c.id} />
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
        fetch('/api/class-delete', {
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
                    classes: this.state.classes.filter(c => c.id !== id)
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

                <h1 style={styling.head}>Manage Classes</h1>

                <Button variant="success" size="lg" style={{ marginLeft: '7%' }} onClick={this.setCreate}>
                    Add Class
                </Button>

                <div style={styling.deckDiv}>
                    {this.renderClasses()}
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