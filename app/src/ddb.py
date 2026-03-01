import os
import boto3

_table = None
_memory_store = {}

table_name = os.getenv("TABLE_NAME")

if table_name:
    # Use real DynamoDB table when TABLE_NAME is provided (e.g. in AWS)
    _table = boto3.resource("dynamodb").Table(table_name)


def put_mapping(short_id: str, url: str):
    """
    Store mapping in DynamoDB when configured, otherwise keep it in memory
    for local development.
    """
    if _table is not None:
        _table.put_item(Item={"id": short_id, "url": url})
    else:
        _memory_store[short_id] = {"id": short_id, "url": url}


def get_mapping(short_id: str):
    """
    Fetch mapping from DynamoDB when configured, otherwise from in-memory store.
    """
    if _table is not None:
        resp = _table.get_item(Key={"id": short_id})
        return resp.get("Item")
    return _memory_store.get(short_id)