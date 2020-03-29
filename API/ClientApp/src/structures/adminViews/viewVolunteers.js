import React, { Component } from 'react'
import { Button, Table } from 'react-bootstrap/'
import { Redirect } from 'react-router-dom'
import BootstrapTable from 'react-bootstrap-table-next'

// es5 
// require('react-bootstrap-table-next/dist/react-bootstrap-table2.min.css');

// es6
import 'react-bootstrap-table-next/dist/react-bootstrap-table2.min.css'

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
                <BootstrapTable 
                    keyField='id' 
                    data={ products } 
                    columns={ columns } 
                />
            </div>
        )
    }
}

const products = [
    {
        'id': '5',
        'name': 'aaa',
        'price': '2001'
    }

]
const columns = [
    {
        dataField: 'pref',
        text: 'Preferred Name'
    }, 
    {
        dataField: 'first',
        text: 'First Name'
    },
    {
        dataField: 'last',
        text: 'Last Name'
    }, 
    {
        dataField: 'role',
        text: 'Role'
    },
    {
        dataField: 'weeks',
        text: 'Weeks Attended'
    },
    {
        dataField: 'phone',
        text: 'Phone Number'
    },
    {
        dataField: 'email',
        text: 'Email'
    },
    {
        dataField: 'ori',
        text: 'Orientation'
    },
    {
        dataField: 'train',
        text: 'Trainings'
    },
    {
        dataField: 'aff',
        text: 'Affiliations'
    },
    {
        dataField: 'ref',
        text: 'Referral'
    },
    {
        dataField: 'lang',
        text: 'Languages'
    },
    {
        dataField: 'class',
        text: 'Classes Interested'
    },
    {
        dataField: 'ages',
        text: 'Ages Interested'
    },
    {
        dataField: 'news',
        text: 'News Letter'
    },
    {
        dataField: 'contact',
        text: 'Contact When Short'
    },
    {
        dataField: 'back',
        text: 'Background Check'
    },
    {
        dataField: 'blue',
        text: 'Blue Shirt'
    },
    {
        dataField: 'nametag',
        text: 'Name Tag'
    },
    {
        dataField: 'interview',
        text: 'Personal Interview Completed'
    },
    {
        dataField: 'year',
        text: 'Year Started'
    },
    {
        dataField: 'birthday',
        text: 'Birthday'
    }
]

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