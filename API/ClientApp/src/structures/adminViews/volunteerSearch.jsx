import React, { Component } from 'react';
import { Form, FormControl, FormGroup, FormLabel, Button, Modal } from 'react-bootstrap/'
import { UserSelectButton } from '../customButtons'

export class VolunteerSearch extends Component {
    constructor(props) {
        super(props)

        this.state = {
            jwt: this.props.jwt,
            name: '',
            success: false,
            volunteers: []
        }

        this.handleNameChange = this.handleNameChange.bind(this)
        this.onSearch = this.onSearch.bind(this);
    }

    handleClose = () => {
        this.props.onClose();
    }

    handleNameChange = (e) => {
        this.setState({
            name: e.target.value
        })
    }

    handleSelect = (id, name) => {
        this.props.onSelect(id, name);

        this.state.volunteers = [];

        this.state.name = '';
    }

    onSearch = () => {
        fetch('/api/volunteer-search?searchString=' + this.state.name, {
            // method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${this.props.jwt}`
            }
        })
        .then((res) => {
            if ((res.status === 200 || res.status === 201)) {
                this.setState({
                    success: true
                })
                return res.json()
            }
            else if ((res.status === 401 || res.status === 400 || res.status === 500)) {
                this.setState({
                    success: false
                })
                return
            }
        })
        .then((data) => {
            console.log(JSON.stringify(data))
            console.log(this.state.success)
            if (this.state.success) {
                console.log(data.volunteers)
                this.setState({
                    volunteers: data.volunteers
                })
            }
        })
        .catch((err) => {
            console.log(err)
        })
    }

    renderVolunteers() {
        if (this.state.volunteers != null) {
            const p = this.state.volunteers.map((v, index) => {
                return (
                    <tr key={index}>
                        <td style={{textAlign:'center'}}>{v.lastName}</td>
                        <td style={{ textAlign: 'center' }}>{v.preferredName}</td>
                        <td style={{ textAlign: 'center' }}>{v.firstName}</td>
                        <td style={{ textAlign: 'center' }}><UserSelectButton onButtonClick={this.handleSelect} value={v.id} name={v.preferredName + ' ' + v.lastName} /></td>
                    </tr>
                )
            });
            return p;
        }
    }

    render() {
        return (
            <Modal show={this.props.show} onHide={this.handleClose} size="lg">
                <Modal.Header closeButton>
                    <Modal.Title>Volunteer Search</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <Form>
                        <FormGroup>
                            <FormControl style={{ display: 'inline', width: '85%', marginRight: '2%' }} type="text" placeholder="Search By Name" value={this.state.name} onChange={this.handleNameChange} />
                            <Button style={{ display: 'inline' }} variant="link" variant="primary"  onClick={this.onSearch}>
                                Search
                            </Button>
                        </FormGroup>
                        <p style={this.state.success ? { color: 'green' } : { color: 'red' }}>{this.state.result}</p>
                    </Form>

                    <table style={{tableLayout:'fixed', width: '100%'}}>
                        <tbody>
                            <tr>
                                <th style={{ textAlign: 'center' }}>Last Name</th>
                                <th style={{ textAlign: 'center' }}>Preferred Name</th>
                                <th style={{ textAlign: 'center' }}>First Name</th>
                                <th></th>
                            </tr>
                            {this.renderVolunteers()}
                        </tbody>
                    </table>

                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={this.handleClose}>
                        Close
                    </Button>
                </Modal.Footer>
            </Modal>
        );
    }
}