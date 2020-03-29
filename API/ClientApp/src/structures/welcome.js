import React, { Component } from 'react'
import { Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

export class Welcome extends Component {
    
    constructor(props) {
        super(props)
        this.state = {
            redirectLogin: false,
            redirectSign: false,
            redirectCal: false
        }
    }
    
    renderRedirect = () => {
        if(this.state.redirectLogin){
            return <Redirect to={{
                pathname: '/login',
                state: { 
                    loggedin: false
                }
            }}/>
        }
        else if(this.state.redirectSign){
            return <Redirect to={{
                pathname: '/signup',
                state: {
                    loggedin: false
                }
            }}/>
        }
        else if(this.state.redirectCal){
            return <Redirect to={{
                pathname: '/general-calendar',
                state: {
                    loggedin: false
                }
            }}/>
        }
        
    }

    setRedirectLogin = () => {
        this.setState({
            redirectLogin: true
        })
    }

    setRedirectSign = () => {
        this.setState({
            redirectSign: true
        })
    }

    setRedirectCal = () => {
        this.setState({
            redirectCal: true
        })
    }
  

  render () {
    return(
        <div>
            <center>
                <div style={styling.header}>
                    <h1>Welcome to the OCC Portal</h1>
                </div>
            </center>
            <center>
                {this.renderRedirect()}
                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectSign}>
                    Sign Up
                </Button>

                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectLogin}>
                    Log In
                </Button>

                <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectCal}>
                    View Calendar
                </Button>
            </center>  
        </div>
    )
  }
}

const styling = {
    header: {
        textAlign: 'center',
        justifyContent: 'center',
        marginTop: '50px'
    },
    butt: {
        marginRight: '25px',
        marginLeft: '25px',
        marginTop: '75px',
        width: '200px',
        height: '200px'
    }
}




