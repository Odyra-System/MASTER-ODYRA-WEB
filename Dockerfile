# Agente vocale del sito Odyra (odyra_web), worker LiveKit Agents self-hosted su Railway (ODYRA CORE).
# Istruzioni e conoscenza NON stanno in questo repository: all'avvio si scaricano dal server del sito
# (SITE_KNOWLEDGE_URL + VOICE_LEAD_SECRET), così chat e voce usano sempre lo stesso testo.
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends gcc g++ \
 && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY core.py agent.py /app/

# Utente senza privilegi; i modelli locali (rilevamento della voce) si scaricano in build
# per evitare l'attesa al primo collegamento.
RUN useradd --create-home --uid 10001 odyra && chown -R odyra /app
USER odyra
RUN python agent.py download-files

CMD ["python", "agent.py", "start"]
