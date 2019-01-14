use std::error::Error;

use lambda_runtime::{error::HandlerError, lambda, Context};
use log::{self, error};
use rust_line_bot_sdk::event::{Event, Events};
use rust_line_bot_sdk::LineBot;
use serde_derive::{Deserialize, Serialize};
use simple_logger;
use std::collections::HashMap;


#[derive(Deserialize, Debug)]
struct Request {
    body: String,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
struct ProxyResponse {
    status_code: u16,
    headers: HashMap<String, String>,
    body: String,
    is_base_64_encoded: bool,
}

fn main() -> Result<(), Box<dyn Error>> {
    simple_logger::init_with_level(log::Level::Debug).unwrap();
    lambda!(handler);

    Ok(())
}

fn handler(e: Request, _c: Context) -> Result<ProxyResponse, HandlerError> {
    let channel_secret_token =
        std::env::var("CHANNEL_ACCESS_TOKEN").expect("CHANNEL_ACCESS_TOKEN should be there na!");

    let line_bot = LineBot::new(&channel_secret_token);

    let events: Events = serde_json::from_str(e.body.as_str()).unwrap();

    for event in events.events.iter() {
        match event {
            Event::Message { reply_token, .. } =>
                line_bot
                    .reply_text(reply_token.as_str(), vec!["อือ"]),
        };
    }

    Ok(ProxyResponse {
        status_code: 200,
        headers: HashMap::new(),
        body: "ok!".to_string(),
        is_base_64_encoded: false,
    })
}
