- -------    Update the fonts that is being used through out this application to use the google font named inter, 
start by updating it generally for my app in the main.dart file on wherever the main logic for the app begins. 

- ------   Based on the Schema below, I want you to create me 2 models that are going to describe the schema and be used for fetching and puting data into that model. 

- Then when you are done, you create their coresponding repositories which will be used only for retriving data from these tables. 

- -- Injury types table
CREATE TABLE injury_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE, -- e.g., 'lower_back', 'shoulder', etc.
    description TEXT -- optional, for more detailed explanation of the injury type
);

-- Main user injuries table
CREATE TABLE user_injuries (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    injury_type_id INTEGER NOT NULL REFERENCES injury_types(id) ON DELETE RESTRICT,
    details TEXT, -- Additional notes/limits for the injury
    reported_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN NOT NULL DEFAULT TRUE, -- Indicates if injury is still current
    resolved_at TIMESTAMP -- When the injury was resolved
);


-------- 

