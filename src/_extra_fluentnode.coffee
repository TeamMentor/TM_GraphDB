String::to_Safe_String   = ()-> @.replace(/[^a-z0-9.\-_]/gi, '-').lower()