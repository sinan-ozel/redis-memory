# Agent Memory

redis-memory provides specialized support for conversational AI agents through the `ConversationMemory` class.

## ConversationMemory Class

`ConversationMemory` extends `Memory` with conversation-specific features:

```python
from redis_memory import ConversationMemory
import uuid

conversation_id = str(uuid.uuid4())
mem = ConversationMemory(conversation_id=conversation_id)
```

## Basic Usage

Store conversation state:

```python
from redis_memory import ConversationMemory

# Create a conversation memory
conv_id = "conversation_123"
mem = ConversationMemory(conversation_id=conv_id)

# Store messages
mem.messages = [
    {"role": "user", "content": "Hello!"},
    {"role": "assistant", "content": "Hi! How can I help you?"}
]

# Store conversation metadata
mem.user_name = "Alice"
mem.created_at = "2025-12-24T10:00:00"
mem.context = {"topic": "technical support"}
```

## Accessing from Different Processes

The conversation state is shared across processes:

```python
# In Agent Process 1
from redis_memory import ConversationMemory

mem = ConversationMemory(conversation_id="conv_123")
mem.messages.append({
    "role": "user",
    "content": "What's the weather?"
})

# In Agent Process 2 (different worker/pod)
mem2 = ConversationMemory(conversation_id="conv_123")
print(mem2.messages)
# Includes the message from Process 1
```

## Integration with LLM Frameworks

### OpenAI

```python
from redis_memory import ConversationMemory
import openai

conv_id = "user_session_abc"
mem = ConversationMemory(conversation_id=conv_id)

# Initialize or load messages
if not hasattr(mem, 'messages'):
    mem.messages = []

# Add user message
user_message = {"role": "user", "content": "Tell me a joke"}
mem.messages.append(user_message)

# Call OpenAI
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=mem.messages
)

# Store assistant response
assistant_message = {
    "role": "assistant",
    "content": response.choices[0].message.content
}
mem.messages.append(assistant_message)
```

### LiteLLM

```python
from redis_memory import ConversationMemory
import litellm

conv_id = "session_xyz"
mem = ConversationMemory(conversation_id=conv_id)

# Initialize conversation
if not hasattr(mem, 'messages'):
    mem.messages = []

# Add message and get response
mem.messages.append({"role": "user", "content": "Hello!"})

response = litellm.completion(
    model="gpt-3.5-turbo",
    messages=mem.messages
)

# Store response
mem.messages.append({
    "role": "assistant",
    "content": response.choices[0].message.content
})
```

## Conversation Context

Store additional context beyond messages:

```python
mem = ConversationMemory(conversation_id=conv_id)

# User profile
mem.user_profile = {
    "name": "Alice",
    "preferences": {"language": "en", "tone": "casual"},
    "history_summary": "Regular customer, technical background"
}

# Conversation state
mem.state = "active"
mem.current_topic = "billing_inquiry"
mem.intent_history = ["greeting", "billing_question"]

# Metadata
mem.started_at = "2025-12-24T10:00:00"
mem.last_activity = "2025-12-24T10:15:00"
mem.total_messages = len(mem.messages) if hasattr(mem, 'messages') else 0
```

## Multi-Agent Systems

Share state between specialized agents:

```python
from redis_memory import ConversationMemory

conv_id = "multi_agent_session"

# Agent 1: Intent Classifier
mem = ConversationMemory(conversation_id=conv_id)
mem.detected_intent = "technical_support"
mem.confidence = 0.95

# Agent 2: Context Manager (different process)
mem2 = ConversationMemory(conversation_id=conv_id)
if mem2.detected_intent == "technical_support":
    mem2.assigned_specialist = "tech_agent_3"

# Agent 3: Specialist (different process)
mem3 = ConversationMemory(conversation_id=conv_id)
if hasattr(mem3, 'assigned_specialist'):
    # Handle the technical query
    mem3.resolution_status = "in_progress"
```

## Conversation Cleanup

Clean up old conversations:

```python
from redis_memory import ConversationMemory
from datetime import datetime, timedelta

def cleanup_old_conversations(conversation_ids, max_age_days=7):
    """Remove conversations older than max_age_days."""
    cutoff_date = datetime.now() - timedelta(days=max_age_days)

    for conv_id in conversation_ids:
        mem = ConversationMemory(conversation_id=conv_id)
        if hasattr(mem, 'last_activity'):
            last_activity = datetime.fromisoformat(mem.last_activity)
            if last_activity < cutoff_date:
                # Clear conversation data
                for attr in dir(mem):
                    if not attr.startswith('_'):
                        try:
                            delattr(mem, attr)
                        except AttributeError:
                            pass
```

## Best Practices

1. **Use unique conversation IDs**: UUIDs or session tokens
2. **Store timestamps**: Track conversation start, end, and last activity
3. **Limit message history**: Trim old messages to manage token limits
4. **Cache user context**: Store user preferences for personalization
5. **Handle disconnections**: redis-memory queues changes when Redis is down
6. **Clean up regularly**: Remove old or inactive conversations

## Example: Complete Chat Bot

```python
from redis_memory import ConversationMemory
import uuid
from datetime import datetime

class ChatBot:
    def __init__(self, user_id):
        self.conv_id = f"user_{user_id}_{uuid.uuid4()}"
        self.memory = ConversationMemory(conversation_id=self.conv_id)

        # Initialize conversation
        if not hasattr(self.memory, 'messages'):
            self.memory.messages = []
            self.memory.created_at = datetime.now().isoformat()

    def send_message(self, user_message):
        """Send a user message and get a response."""
        # Store user message
        self.memory.messages.append({
            "role": "user",
            "content": user_message,
            "timestamp": datetime.now().isoformat()
        })

        # Generate response (placeholder)
        response = self.generate_response(user_message)

        # Store assistant message
        self.memory.messages.append({
            "role": "assistant",
            "content": response,
            "timestamp": datetime.now().isoformat()
        })

        # Update metadata
        self.memory.last_activity = datetime.now().isoformat()
        self.memory.message_count = len(self.memory.messages)

        return response

    def generate_response(self, message):
        """Generate a response (integrate your LLM here)."""
        # Placeholder - integrate OpenAI, LiteLLM, etc.
        return f"Echo: {message}"

    def get_history(self):
        """Get conversation history."""
        return self.memory.messages if hasattr(self.memory, 'messages') else []

# Usage
bot = ChatBot(user_id="alice_123")
response = bot.send_message("Hello!")
print(response)  # "Echo: Hello!"

# From another process/pod
bot2 = ChatBot(user_id="alice_123")
history = bot2.get_history()
print(len(history))  # 2 (user + assistant messages)
```
