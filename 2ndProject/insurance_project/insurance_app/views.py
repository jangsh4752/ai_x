from django.shortcuts import render
from datetime import date
import asyncio
from .insurance_api import fetch_insurance_premium
from .rag_search import rag_search
from .llm_client import summarize_text, generate_recommendation_reason

def calculate_age(birth_date):
    today = date.today()
    return today.year - birth_date.year - ((today.month, today.day) < (birth_date.month, birth_date.day))

def insurance_form(request):
    return render(request, "insurance_form.html")

def recommend_insurance(request):
    if request.method == "POST":
        user = request.user
        coverage_options = request.POST.getlist("coverage_options")
        premiums = asyncio.run(fetch_insurance_premium(user, coverage_options))
        recommendations = []
        for p in premiums["data"]:
            insurer, premium, terms = p["insurerName"], p["premium"], p.get("specialTerms", [])
            score = len(terms) * 10
            reason = generate_recommendation_reason(insurer, premium, terms, [])
            recommendations.append({"insurer": insurer, "premium": premium,
                                    "coverage": p["coverageSummary"], "special_terms": terms,
                                    "score": score, "reason": reason})
        recommendations = sorted(recommendations, key=lambda x: x["score"], reverse=True)
        return render(request, "recommendation.html", {"recommendations": recommendations[:3]})
