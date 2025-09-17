from google.cloud import storage


class StorageClient:
    def __init__(self, bucket_name: str) -> None:
        self.bucket_name = bucket_name
        self._client = storage.Client()
        self._bucket = self._client.bucket(bucket_name)

    def upload_bytes(self, data: bytes, path: str, content_type: str) -> str:
        blob = self._bucket.blob(path)
        blob.upload_from_string(data, content_type=content_type)
        return blob.public_url
