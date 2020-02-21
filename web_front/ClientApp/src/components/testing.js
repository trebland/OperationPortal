import React, { Component } from 'react'
import ReactLoading from "react-loading";
import { Redirect } from 'react-router-dom'
// import { Section, Title, Article, Prop, list } from "./NotLoggedIn/generic";
import "./styles.css";

// https://www.npmjs.com/package/react-loading

export class Testing extends Component {

    constructor(props){
        super(props);
        this.state = {
            username: this.props.location.state.username,
            loggedin: this.props.location.state.loggedin,
            redirect: false
        }
    }

    componentDidMount() {
        this.id = setTimeout(() => this.setState({ redirect: true }), 1000)
    }

    componentWillUnmount() {
        clearTimeout(this.id)
    }

    render() {
        const loading = (
            <div>
                    {/* needs styling, center please */}
                    <h1>Your calendar is loading</h1>
                    <ReactLoading type="spokes" color="fff"/>
            </div>
        )
        return (
            <div>
                {loading}
                this.state.redirect ? <Redirect to="/user" /> : {loading}
            </div>
        )
    }
}


