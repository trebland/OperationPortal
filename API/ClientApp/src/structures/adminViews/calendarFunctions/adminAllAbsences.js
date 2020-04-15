import React, { Component } from 'react';
import { Button, Form } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'


export class AdminAllAbsences extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false,
            jwt: props.location.state.jwt
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
                    Back to Dashboard
                </Button>
                <center>
                    <h1>All Absences</h1>
                </center>
            </div>
        )
    }
}

const styling = {
    cal: {
        height: '550px',
        padding: '20px 20px'
    },
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
    },
    add: {
        marginBottom: '25px'
    }
} 