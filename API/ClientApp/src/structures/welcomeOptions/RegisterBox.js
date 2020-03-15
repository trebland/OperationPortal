import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'

export class RegisterBox extends Component {

    constructor(props) {
      super(props);
      this.state = {
        firstname: "",
        lastname: "",
        email: "",
        password: "",
        redirectDash: false
        // redirect: false,
        // result: ""
      };
      this.handleFirstnameChange = this.handleFirstnameChange.bind(this);
      this.handleLastnameChange = this.handleLastnameChange.bind(this);
      this.handlePasswordChange = this.handlePasswordChange.bind(this);
    }

    componentDidMount() {
      this.mounted = true
    }

    componentWillUnmount() {
      this.mounted = false
    }

    onSubmit = (e) => {
        try{
            fetch('https://www.operation-portal.com/api/auth/register' , {
                method: "POST",
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(this.state)
            })
            .then(res => res.json())
            .then(
                (result) => {
                    console.log(result)
                },
                (error) => {
                    this.setState({
                      isLoaded: true,
                      error
                    });
                }
            )
        }
        catch(e) {
            console.log("Did not connect")
        }
    }

    setRedirectDash = () => {
        this.setState({
            redirectDash: true
        })
    }


    renderRedirect = () => {
      if (this.state.redirect) {
        return <Redirect to={{
            pathname: '/login',
            state: {

            }
        }}/>
      }
      else if(this.state.redirectDash) {
          return <Redirect to={{
              pathname: '/'
          }}/>
      }
    }

    handleFirstnameChange = (e) => {
      this.setState({
        firstname: e.target.value
      })
      console.log(this.state.firstname)
    }

    handleLastnameChange = (e) => {
      this.setState({
        lastname: e.target.value
      })
      console.log(this.state.lastname)
    }

    handleEmailChange = (e) => {
      this.setState({
        email: e.target.value
      })
      console.log(this.state.email)
    }

    handlePasswordChange = (e) => {
      this.setState({
        password: e.target.value
      })
      console.log(this.state.password)
    }
  
    render() {
      return (
        <div>
            <Button variant="primary" size="lg" style={styling.butt} onClick={this.setRedirectDash}>
                Back to Dashboard
            </Button>
          <div>
            <h1 style={styling.header}>Register</h1>
          </div>
          <div style={styling.outerDiv}>

              <Form style={styling.formDiv}>
                <FormGroup>
                  <FormLabel>First Name</FormLabel>
                  <FormControl type="text" placeholder="First Name" value={this.state.firstname} onChange={this.handleFirstnameChange}/>
                </FormGroup>

                <FormGroup>
                  <FormLabel>Last Name</FormLabel>
                  <FormControl type="text" placeholder="Last Name" value={this.state.lastname} onChange={this.handleLastnameChange}/>
                </FormGroup>

                <FormGroup>
                  <FormLabel>Email</FormLabel>
                  <FormControl type="email" placeholder="Email" value={this.state.email} onChange={this.handleEmailChange}/>
                </FormGroup>

                <FormGroup controlId="formBasicPassword">
                  <FormLabel>Password</FormLabel>
                  <Form.Control type="password" placeholder="Password" value={this.state.password} onChange={this.handlePasswordChange}/>
                </FormGroup>

                <div>
                    <center>
                        {this.renderRedirect()}
                        <Button type="submit" size="lg" onClick={this.onSubmit} >
                            Submit
                        </Button>
                    </center>
                </div>

              </Form>

          </div>
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
    butt: {
        marginTop: '15px',
        marginLeft: '15px'
    },
    header: {
        textAlign: 'center',
        justifyContent: 'center',
        marginTop: '40px'
    }
}