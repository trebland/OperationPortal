import React, { Component } from 'react';
import { Button, Card } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'


export class AdminJobRoster extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt,
        }
    }

    componentWillUnmount = () => {
        this.mounted = false
    }
    
    componentDidMount = () => {
        this.mounted = true
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    renderRedirect = () => {
        if(this.state.redirect) {
            return (
                <Redirect to={{
                    pathname: '/admin-calendar',
                    state: {
                        jwt: this.state.jwt
                    }
                }}/>
            )
        }
    }

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Calendar
                </Button>

                <h1 style={styling.head}>Job Roster for [date]</h1>
            </div>
        )
    }
}

const styling = {
    head: {
        marginBottom: '15px',
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
    }
}