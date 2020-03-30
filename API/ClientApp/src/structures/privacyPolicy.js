import React, { Component } from 'react'
import { Redirect } from 'react-router-dom'
import { Button } from 'react-bootstrap'


export class PrivacyPolicy extends Component {
    constructor(props) {
        super(props)
        this.state = {
            redirect: false,
            loggedin: props.location.state.loggedin
        }
    }

    setRedirect = () => {
        this.setState({
            redirect: true
        })
    }

    renderRedirect = () => {
        if(this.state.redirect) {
            return <Redirect to={{
                pathname: '/',
                loggedin: false
            }}/>
        }
    }

    render() {
        return (
            <div>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirect}>
                    Back to Dashboard
                </Button>
                <div style={styling.outderdiv}>
                    <center>
                        <h1>Privacy Policy of Orlando Children’s Church</h1>
                    </center>
                </div>
                
                
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