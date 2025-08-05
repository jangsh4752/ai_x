from pinecone import Pinecone, ServerlessSpec
from django.conf import settings

pc = Pinecone(api_key=settings.PINECONE_API_KEY)

def create_index():
    if "insurance-clauses" not in [i["name"] for i in pc.list_indexes()]:
        pc.create_index(
            name="insurance-clauses",
            dimension=384,
            metric="cosine",
            spec=ServerlessSpec(cloud="gcp", region=settings.PINECONE_ENV)
        )

def get_index():
    return pc.Index("insurance-clauses")
