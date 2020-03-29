import React, { Component } from 'react'
import { Button, Table } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

// https://react-bootstrap-table.github.io/react-bootstrap-table2/docs/basic-celledit.html

export class ViewVolunteers extends Component {
    constructor(props) {
        super(props)
        this.state = {
            jwt: props.location.state.jwt,
            loggedin: props.location.state.loggedin,
            redirect: false
        }
        console.log(this.state.jwt)
    }

    renderRedirect = () => {
        if(this.state.redirect) {
            return <Redirect to={{
                pathname: '/admin-dashboard',
                state: {
                    jwt: this.state.jwt,
                    loggedin: this.state.loggedin
                }
            }}/>
        }
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>
                <Table>

                </Table>
            </div>
        )
    }
}

const styling = {
    head: {
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