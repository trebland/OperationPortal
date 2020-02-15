import React, { Component } from 'react'
import ReactLoading from "react-loading";
import { Section, Title, Article, Prop, list } from "./generic";
import "./styles.css";

// https://www.npmjs.com/package/react-loading

export class Testing extends Component {

    constructor(props){
        super(props);
        this.state = {
            username: this.props.location.state.username,
            loggedin: this.props.location.state.loggedin
        }
    }
    render() {
        return (
            <div>
                <h1>Your calendar is loading</h1>
                <ReactLoading type="spokes" color="fff"/>
            </div>
        )
    }
}


