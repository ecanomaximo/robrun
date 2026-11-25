import hashlib, uuid, sys

SECRET = 'MR_ROBRUN_SECRET_KEY_2026'

def generate_key(tier):
    rand_part = uuid.uuid4().hex[:8].upper()
    data = f'{tier}-{rand_part}-{SECRET}'
    sig = hashlib.sha256(data.encode()).hexdigest()[:6].upper()
    return f'MR-{tier}-{rand_part}-{sig}'

def generate_batch(count=5):
    plans = [('7D', '7 Dias'), ('30D', '30 Dias'), ('LIFE', 'Vitalício')]
    result = {}
    for code, label in plans:
        result[label] = [generate_key(code) for _ in range(count)]
    return result

if __name__ == '__main__':
    batch = generate_batch(5)
    with open('chaves_venda.txt', 'w', encoding='utf-8') as f:
        f.write("=== CHAVES DE ACESSO MR ROB RUN ===\n")
        f.write("Geradas para entrega automatica no bot/vendas\n\n")
        for label, keys in batch.items():
            f.write(f"--- PLANO {label.upper()} ---\n")
            for k in keys:
                f.write(f"{k}\n")
            f.write("\n")
    print("Chaves salvas em chaves_venda.txt!")
    for label, keys in batch.items():
        print(f"\n{label}:")
        for k in keys:
            print("  ", k)
